--166. List�zzuk egy list�ban a szerz�k keresztnev�t �s sz�let�si h�napj�t illetve a tagok keresztnev�t �s sz�let�si h�napj�t. Minden n�v, h�nap p�ros annyiszor
--szerepeljen, ah�nyszor a t�bl�kban el�fordul
SELECT konyvtar.szerzo.vezeteknev, to_char(konyvtar.szerzo.szuletesi_datum,'mm')
FROM konyvtar.szerzo
union all --tartalmazhat ugyanolyan sorokat is
SELECT konyvtar.tag.keresztnev, to_char(konyvtar.tag.szuletesi_datum,'mm')
FROM konyvtar.tag;

--167. List�zzuk egy list�ban a szerz�k keresztnev�t �s sz�let�si h�napj�t illetve a tagok keresztnev�t �s sz�let�si h�napj�t. Minden n�v, h�nap p�ros csak
--egyszer szerepeljen.
SELECT konyvtar.szerzo.vezeteknev, to_char(konyvtar.szerzo.szuletesi_datum,'mm')
FROM konyvtar.szerzo
union -- nem tartalmazhat ugyanolyan sorokat is
SELECT konyvtar.tag.keresztnev, to_char(konyvtar.tag.szuletesi_datum,'mm')
FROM konyvtar.tag;

--168. Melyek azok a keresztnevek, amelyek szerz� keresztneve is �s egyben valamelyik tag� is.
SELECT szerzo.keresztnev
FROM konyvtar.szerzo
intersect
SELECT tag.keresztnev
FROM konyvtar.tag;

SELECT sz.keresztnev
FROM konyvtar.szerzo sz inner join konyvtar.tag t
ON sz.keresztnev = t.keresztnev
GROUP BY sz.keresztnev;

--169. Melyek azok a keresztnevek, amelyek valamelyik szerz� keresztneve, de egyetlen tag� sem?
SELECT keresztnev--A
FROM konyvtar.szerzo
minus--A/B
SELECT keresztnev--B
FROM konyvtar.tag;

--170. Tegy�k egy list�ba a k�nyvek t�m�it �s �rait illetve a k�nyvek kiad�it �s �rait.
SELECT tema, ar
FROM konyvtar.konyv
union
SELECT kiado, ar
FROM konyvtar.konyv;

--171. Tegy�k egy list�ba a szerz�k keresztneveit, sz�let�si d�tumait, besorol�sukk�nt null �rt�ket felt�ntetve �s a tagok keresztneveit, sz�let�si d�tumait �s besorol�sait
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), null AS besorol�s
FROM konyvtar.szerzo
union all
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), besorolas
FROM konyvtar.tag;

--172. Tegy�k egy list�ba a szerz�k keresztneveit, sz�let�si d�tumait, besorol�sukk�nt 'szerz�' �rt�ket felt�ntetve �s a tagok keresztneveit, sz�let�si d�tumait �s besorol�sait.
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), 'szerz�' AS besorol�s
FROM konyvtar.szerzo
union all
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), besorolas
FROM konyvtar.tag;

--DICTIONARY
--az �sszes k�nyvt�r lek�rdez�se
SELECT *
FROM DICTIONARY;

--T�bl�k lek�rdez�se
--az �sszes lek�rdez�se amihez jogosults�gunk van
SELECT *
FROM all_tables;
--a felhaszn�l� �lltal l�trehozott t�bl�k
SELECT *
FROM user_tables;

--Objektumok lek�rdez�se
SELECT *
FROM tab;

--K�nyvt�r felhaszn�l� t�bl�i
SELECT *
FROM all_tables
WHERE owner='KONYVTAR';

--Az Account adatai
SELECT *
FROM user_users;

--Kik az u_ kezdet� felhaszn�l�k? -- _ pontosan egy karatker, teh�t ezt nem lehet teljesen j�l lek�rdezni
SELECT *
FROM all_users
WHERE upper(username) LIKE 'U\_%' escape '\';--csak �gy lehet megoldani

SELECT *
FROM all_tab_columns
WHERE owner='KONYVTAR' and Table_Name='KONYV';

--------------------------------------------------------------------------------Osszetett lekerdezesek-----------------------------------------------------------------------------------------------------------------
--144. Mely k�nyvek valamely p�ld�ny�t k�lcs�n�zt�k ki 3-n�l kevesebbszer?
SELECT ko.konyv_azon, cim, count(kolcsonzesi_datum)
FROM konyvtar.kolcsonzes kk right outer join konyvtar.konyvtari_konyv kv on kk.leltari_szam=kv.leltari_szam right outer join konyvtar.konyv ko on ko.konyv_azon=kv.konyv_azon
GROUP BY ko.konyv_azon, cim
HAVING COUNT(kolcsonzesi_datum)<3;

--120. Keress�k azokat a szerz�ket, akik krimi, sci-fi, horror t�m�j� k�nyvek meg�r�s��rt 2 milli�n�l t�bb �sszhonor�riumot kaptak
SELECT sz.vezeteknev ||' '|| sz.keresztnev AS nev,sum(ksz.honorarium) AS ossz_honorarium
FROM konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz on sz.szerzo_azon=ksz.szerzo_azon inner join konyvtar.konyv ko on ksz.konyv_azon = ko.konyv_azon
WHERE ko.tema in ('krimi','sci-fi','horror')
GROUP BY sz.szerzo_azon, sz.vezeteknev,sz.keresztnev
HAVING SUM(ksz.honorarium)>2000000;

--155. Melyik k�nyvh�z tartozik a legkevesebb p�ld�ny?
SELECT ko.cim, ko.konyv_azon, (count(leltari_szam))
FROM konyvtar.konyv ko LEFT OUTER JOIN konyvtar.konyvtari_konyv kv on ko.konyv_azon=kv.konyv_azon
GROUP BY ko.konyv_azon, ko.cim
HAVING count(leltari_szam)=(SELECT min(count(leltari_szam))
FROM konyvtar.konyvtari_konyv
GROUP BY konyv_azon);

/*
-- Halmazm�veletek
Uni�: union all: k�t vagy t�bb lek�rdez�sb�l megjelen�ti a lek�rdez�sek �sszes adat�t unio: csak egyszer jelen�ti meg az �sszes adatot
Metszet: intersect
K�l�nbs�g: minus A/B

--Adatsz�t�rn�zetek
K�t r�sze van egy 
fizikai: itt vannak t�nylegesen az adatok, amit le is k�rdez�nk
adatsz�t�r: meta adatok vannak, milyen tulajdons�gai vavnnak egy adott attrib�tumnak, pl. felvehet�nk e null �rt�kekeket, milyen kapcsolataik vannak
ezen k�v�l m�g benne van az attrib�tum s�ma, �s a felhaszn�l�i enged�lyek -- P�novics pdf
DICTIONARY
*/