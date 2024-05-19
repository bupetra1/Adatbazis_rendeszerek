--166. Listázzuk egy listában a szerzõk keresztnevét és születési hónapját illetve a tagok keresztnevét és születési hónapját. Minden név, hónap páros annyiszor
--szerepeljen, ahányszor a táblákban elõfordul
SELECT konyvtar.szerzo.vezeteknev, to_char(konyvtar.szerzo.szuletesi_datum,'mm')
FROM konyvtar.szerzo
union all --tartalmazhat ugyanolyan sorokat is
SELECT konyvtar.tag.keresztnev, to_char(konyvtar.tag.szuletesi_datum,'mm')
FROM konyvtar.tag;

--167. Listázzuk egy listában a szerzõk keresztnevét és születési hónapját illetve a tagok keresztnevét és születési hónapját. Minden név, hónap páros csak
--egyszer szerepeljen.
SELECT konyvtar.szerzo.vezeteknev, to_char(konyvtar.szerzo.szuletesi_datum,'mm')
FROM konyvtar.szerzo
union -- nem tartalmazhat ugyanolyan sorokat is
SELECT konyvtar.tag.keresztnev, to_char(konyvtar.tag.szuletesi_datum,'mm')
FROM konyvtar.tag;

--168. Melyek azok a keresztnevek, amelyek szerzõ keresztneve is és egyben valamelyik tagé is.
SELECT szerzo.keresztnev
FROM konyvtar.szerzo
intersect
SELECT tag.keresztnev
FROM konyvtar.tag;

SELECT sz.keresztnev
FROM konyvtar.szerzo sz inner join konyvtar.tag t
ON sz.keresztnev = t.keresztnev
GROUP BY sz.keresztnev;

--169. Melyek azok a keresztnevek, amelyek valamelyik szerzõ keresztneve, de egyetlen tagé sem?
SELECT keresztnev--A
FROM konyvtar.szerzo
minus--A/B
SELECT keresztnev--B
FROM konyvtar.tag;

--170. Tegyük egy listába a könyvek témáit és árait illetve a könyvek kiadóit és árait.
SELECT tema, ar
FROM konyvtar.konyv
union
SELECT kiado, ar
FROM konyvtar.konyv;

--171. Tegyük egy listába a szerzõk keresztneveit, születési dátumait, besorolásukként null értéket feltüntetve és a tagok keresztneveit, születési dátumait és besorolásait
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), null AS besorolás
FROM konyvtar.szerzo
union all
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), besorolas
FROM konyvtar.tag;

--172. Tegyük egy listába a szerzõk keresztneveit, születési dátumait, besorolásukként 'szerzõ' értéket feltüntetve és a tagok keresztneveit, születési dátumait és besorolásait.
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), 'szerzõ' AS besorolás
FROM konyvtar.szerzo
union all
SELECT keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd'), besorolas
FROM konyvtar.tag;

--DICTIONARY
--az összes könyvtár lekérdezése
SELECT *
FROM DICTIONARY;

--Táblák lekérdezése
--az összes lekérdezése amihez jogosultságunk van
SELECT *
FROM all_tables;
--a felhasználó álltal létrehozott táblák
SELECT *
FROM user_tables;

--Objektumok lekérdezése
SELECT *
FROM tab;

--Könyvtár felhasználó táblái
SELECT *
FROM all_tables
WHERE owner='KONYVTAR';

--Az Account adatai
SELECT *
FROM user_users;

--Kik az u_ kezdetû felhasználók? -- _ pontosan egy karatker, tehát ezt nem lehet teljesen jól lekérdezni
SELECT *
FROM all_users
WHERE upper(username) LIKE 'U\_%' escape '\';--csak így lehet megoldani

SELECT *
FROM all_tab_columns
WHERE owner='KONYVTAR' and Table_Name='KONYV';

--------------------------------------------------------------------------------Osszetett lekerdezesek-----------------------------------------------------------------------------------------------------------------
--144. Mely könyvek valamely példányát kölcsönözték ki 3-nál kevesebbszer?
SELECT ko.konyv_azon, cim, count(kolcsonzesi_datum)
FROM konyvtar.kolcsonzes kk right outer join konyvtar.konyvtari_konyv kv on kk.leltari_szam=kv.leltari_szam right outer join konyvtar.konyv ko on ko.konyv_azon=kv.konyv_azon
GROUP BY ko.konyv_azon, cim
HAVING COUNT(kolcsonzesi_datum)<3;

--120. Keressük azokat a szerzõket, akik krimi, sci-fi, horror témájú könyvek megírásáért 2 milliónál több összhonoráriumot kaptak
SELECT sz.vezeteknev ||' '|| sz.keresztnev AS nev,sum(ksz.honorarium) AS ossz_honorarium
FROM konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz on sz.szerzo_azon=ksz.szerzo_azon inner join konyvtar.konyv ko on ksz.konyv_azon = ko.konyv_azon
WHERE ko.tema in ('krimi','sci-fi','horror')
GROUP BY sz.szerzo_azon, sz.vezeteknev,sz.keresztnev
HAVING SUM(ksz.honorarium)>2000000;

--155. Melyik könyvhöz tartozik a legkevesebb példány?
SELECT ko.cim, ko.konyv_azon, (count(leltari_szam))
FROM konyvtar.konyv ko LEFT OUTER JOIN konyvtar.konyvtari_konyv kv on ko.konyv_azon=kv.konyv_azon
GROUP BY ko.konyv_azon, ko.cim
HAVING count(leltari_szam)=(SELECT min(count(leltari_szam))
FROM konyvtar.konyvtari_konyv
GROUP BY konyv_azon);

/*
-- Halmazmûveletek
Unió: union all: két vagy több lekérdezésbõl megjeleníti a lekérdezések összes adatát unio: csak egyszer jeleníti meg az összes adatot
Metszet: intersect
Különbség: minus A/B

--Adatszótárnézetek
Két része van egy 
fizikai: itt vannak ténylegesen az adatok, amit le is kérdezünk
adatszótár: meta adatok vannak, milyen tulajdonságai vavnnak egy adott attribútumnak, pl. felvehetünk e null értékekeket, milyen kapcsolataik vannak
ezen kívül még benne van az attribútum séma, és a felhasználói engedélyek -- Pánovics pdf
DICTIONARY
*/