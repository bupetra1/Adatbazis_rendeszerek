--SQL f�ggv�nyek
--28. List�zzuk ki a k�nyvek c�m�t, �s oldalank�nti �r�t. Ez ut�bbi �rt�kkel pr�b�ljuk ki a trunc �s a round f�ggv�nyek m�k�d�s�t.
SELECT cim, ar/oldalszam, trunc(ar/oldalszam), round(ar/oldalszam)
FROM konyvtar.konyv;

--29. List�zzuk ki -5 abszol�t �rt�k�t!
SELECT abs(-5)
FROM dual;

--30. Mennyi 12*50 �s 25-nek a gy�ke?
SELECT 12*50, sqrt(25)
FROM dual;

--31. List�zzuk ki az 'almafa' sztring hossz�t!
SELECT length('almafa')
FROM dual;

--32. List�zzuk ki, hogy az 'almafa' sztringben az 'af' sztring h�nyadik karaktert�l kezd�dik!
SELECT instr('almafa','af')
FROM dual;

--33. List�zzuk ki a tagok nev�t �s nem�t. Az utols� oszlopon szerepeljen a 'f�rfi' karaktersorozat, ha a nem 'f', a 'n�', ha a nem 'n', �s '?' egy�bk�nt.
SELECT vezeteknev ||' '|| keresztnev, nem, decode(nem,'f','f�rfi','n','n�','?')
FROM konyvtar.tag;

--34. List�zzuk ki a k�nyvek oldalsz�m�t! A 2. oszlopban is a k�nyvek oldalsz�ma szerepeljen, azonban ha az nincs megadva, akkor -1 jelenjen meg.
SELECT oldalszam, decode(oldalszam,null,'-1',oldalszam)
FROM konyvtar.konyv;

--35. List�zzuk ki a k�nyvek c�m�t �s t�m�j�t. A t�m�t m�g egyszer is jelen�ts�k meg �gy, hogy ha null �rt�k, akkor helyette 3 db '*'-ot �rjunk.
SELECT cim, tema, decode(tema,null,'***',tema) --nvl(tema,'***')
FROM konyvtar.konyv
ORDER BY tema ASC nulls first;

--36. List�zzuk ki a felhaszn�l�i nev�nket!
SELECT user
FROM dual;

--37. F�zz�k �ssze az 'alma' �s a 'fa' szavakat k�tf�le megold�ssal!
SELECT 'alma' ||''|| 'fa'
FROM dual;
SELECT concat('alma','fa')
FROM dual;

--38. List�zzuk ki az 'almafa' sz�t nagy kezd�bet�vel!
SELECT initcap('almafa')
FROM dual;

--39. List�zzuk ki a tagok vezet�knev�t, majd a tagok nev�t csupa kisbet�vel, �s csupa nagybet�vel!
SELECT vezeteknev, lower(vezeteknev), upper(vezeteknev)
FROM konyvtar.tag;

--40. List�zzuk ki a tagok vezet�knev�t! Pr�b�ljuk ki a substr f�ggv�ny m�k�d�s�t, a 3. karaktert�l kezd�d�en vegy�nk 4 karaktert a vezet�kn�vb�l.
SELECT vezeteknev, substr(vezeteknev,3,4)
FROM konyvtar.tag;

--41. List�zzuk ki a tagok vezet�kneveit! Pr�b�ljuk ki a replace f�ggv�nyt. Ha a vezet�kn�vben szerepel az 'er' karaktersorozat, cser�lj�k le 3 db *-ra.
SELECT vezeteknev, replace(vezeteknev,'er','***')
FROM konyvtar.tag;

--42. List�zzuk ki azokat a tagokat, akinek a vezet�knev�ben legal�bb k�t 'a' bet� szerepel, mindegy, hogy kicsi vagy nagy.
SELECT *
FROM konyvtar.tag
WHERE lower(vezeteknev) like '%a%a%';

--43. List�zzuk ki a tagok sz�let�si d�tum�t!
SELECT to_char(szuletesi_datum,'yyyy.mm.dd. day hh24:mi:ss') AS datum --mm:9, mon:szept., month: szeptember
FROM konyvtar.tag;

--44. �rjuk ki a mai d�tumot, a holnapi d�tumot, az egy h�ttel ezel�tti d�tumot �s a 12 �r�val ezel�tti d�tumot. A d�tumok mellett az id� is szerepeljen.
SELECT to_char(sysdate,'yyyy.mm.dd hh24:mi:ss'),to_char(sysdate+1,'yyyy.mm.dd hh24:mi:ss'),to_char(sysdate-7,'yyyy.mm.dd hh24:mi:ss'),to_char(sysdate-0.5,'yyyy.mm.dd hh24:mi:ss')
FROM dual;

--45. List�zzuk ki a mai d�tumot, a k�t h�nappal k�s�bbi d�tumot �s a k�t h�nappal kor�bbi d�tumot
SELECT to_char(sysdate,'yyyy.mm.dd hh24:mi:ss') as ma, to_char(add_months(sysdate,2),'yyyy.mm.dd hh24:mi:ss')
FROM dual;

--47. H�ny nap telt el 2000 janu�r 1 �ta?
SELECT sysdate-to_date('2000.01.01.','yyyy.mm.dd.')
FROM dual;

--48. H�ny �v telt el 2000 janu�r 1 �ta?
SELECT (sysdate-to_date('2000.01.01.','yyyy.mm.dd.'))/12
FROM dual;

--49. Kik a 30 �vn�l fiatalabb tagok?
SELECT vezeteknev, keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd') as szuletesi_datum
FROM konyvtar.tag
WHERE months_between(sysdate,szuletesi_datum)/12<30;

--50. Melyek azok a tagok, akik 2000.01.01 el�tt sz�lettek �s akiknek a besorol�sa nyugd�djas, vagy feln�tt?
SELECT vezeteknev, keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd') as szuletesidatum
FROM konyvtar.tag
WHERE szuletesi_datum<to_date('2000.01.01.','yyyy.mm.dd.') and besorolas in ('nyugd�jas', 'feln�tt');

--51. Melyek azok a tagok, akiknek a c�m�ben szerepel az '�t' sz�, vagy a nev�kben pontosan k�t 'e' bet� szerepel? A lista legyen n�v szerint rendezve.
SELECT *
FROM konyvtar.tag
WHERE lower(cim) LIKE '%�t%' or (lower(vezeteknev ||''|| keresztnev) LIKE '%e%e%' and lower(vezeteknev ||''|| keresztnev) not like '%e%e%e%')
ORDER BY vezeteknev ASC, keresztnev ASC;

--53. Azokat a tagokat keress�k, akinek a nev�ben legal�bb kett� 'e' bet� szerepel �s igaz r�juk, hogy 40 �vn�l fiatalabbak vagy besorol�suk gyerek.
SELECT *
FROM konyvtar.tag
WHERE lower(vezeteknev ||''|| keresztnev) LIKE '%e%e%' and (besorolas='gyerek' or month_between(sysdate,szuletesi_datum)/12<40);
/*
********************MATEMATIKAI F�GGV�NYEK ********************
KEREK�T�SRE HASZN�LAND� F�GGV�NYEK
trunc(): Ha kisebb mint, 0 akkor lev�gja az elej�t �s 1-et ad vissza. Lev�gja a sz�mok eg�sz �rt�k�t alapb�l, de meg lehet adni, hogy h�ny tizedesjegyig menjen.
round(): Matematika szab�lyai szerint kerek�t. Alapb�l 0 tizedesjegyre kerek�t. Pontosabb.

M�VELETI F�GGV�NY
abs(): Az elemek abszol�t �rt�k�t adja vissza
sqrt(): N�gyzetgy�k f�ggv�ny

********************SZ�VEG F�GGV�NYEK ********************
length(''): Megadja, h�ny karakter hossz� az adott kifejez�s
instr('',''): Visszaadja, hogy a m�sodik argumentumk�nt megadott kifejez�s, hanyadik karaktert�l kezd�dik, az 1. argument�ban
||' '||: �sszef�z t�bb kifejez�st
concat(): �sszef�z k�t kifejez�st
initcap(): A bele�rt kifejez�st nagy kezd�bet�vel kezdi el
lower(): Csupa kisbet�vel �rja ki a bele�rt kifejez�st
upper(): Csupa nagybet�vel �rja ki a bele�rt kifejez�st
substr(kifejezes,honnan,mennyit): Visszaad egy adott tartom�nyt a megadott kifejez�sb�l
replace(honnan,mit,mire): Egy adott kifejez�sben, ha szerepel a 2. argumentumban megadott kifejez�s, akkor kicser�li a 3. argumentumban l�v� kifejez�sre
hol like '%a%a%': Visszaadja azokat az �rt�keket, amikben 2 db a bet� szerepel
to_char(): Meg lehet benne adni, hogy egy kifejez�s, milyen form�tumban szeretn�nk visszakapni

************************FELT�TELES F�GGV�NY***********************
decode(oszlop_nev,'ha 1','�rja ezt ki','ha 2','akkor �rja ezt ki','k�l�nben ezt')
nvl(mit_cser�ljen,'erre cser�lje'): Ha null �rt�ket, tal�l akkor kicser�li a 2. argumentumra

************************ID� F�GGV�NY***********************
sysdate: aktu�lis d�tum
sysdate+1: 1 nappal k�s�bbi d�tum
add_months(sysdate,2): Hozz�adja a d�tumhoz a 2. argumentumban megadott sz�mnyi h�napot
to_date('2000.01.01.','yyyy.mm.dd.'): �talak�t�s d�tum form�tumba
months_between(sysdate,szuletesi_datum): H�ny h�nap telt el a k�t d�tumm k�z�tt
************************OPER�TOROK***********************
%: b�rmennyi karakter lehet k�z�tt�k
?: adott helyen szerepel egy karakter
_: 1 karakter el�fordul�s�ra j�
*/