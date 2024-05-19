--SQL függvények
--28. Listázzuk ki a könyvek címét, és oldalankénti árát. Ez utóbbi értékkel próbáljuk ki a trunc és a round függvények mûködését.
SELECT cim, ar/oldalszam, trunc(ar/oldalszam), round(ar/oldalszam)
FROM konyvtar.konyv;

--29. Listázzuk ki -5 abszolút értékét!
SELECT abs(-5)
FROM dual;

--30. Mennyi 12*50 és 25-nek a gyöke?
SELECT 12*50, sqrt(25)
FROM dual;

--31. Listázzuk ki az 'almafa' sztring hosszát!
SELECT length('almafa')
FROM dual;

--32. Listázzuk ki, hogy az 'almafa' sztringben az 'af' sztring hányadik karaktertõl kezdõdik!
SELECT instr('almafa','af')
FROM dual;

--33. Listázzuk ki a tagok nevét és nemét. Az utolsó oszlopon szerepeljen a 'férfi' karaktersorozat, ha a nem 'f', a 'nõ', ha a nem 'n', és '?' egyébként.
SELECT vezeteknev ||' '|| keresztnev, nem, decode(nem,'f','férfi','n','nõ','?')
FROM konyvtar.tag;

--34. Listázzuk ki a könyvek oldalszámát! A 2. oszlopban is a könyvek oldalszáma szerepeljen, azonban ha az nincs megadva, akkor -1 jelenjen meg.
SELECT oldalszam, decode(oldalszam,null,'-1',oldalszam)
FROM konyvtar.konyv;

--35. Listázzuk ki a könyvek címét és témáját. A témát még egyszer is jelenítsük meg úgy, hogy ha null érték, akkor helyette 3 db '*'-ot írjunk.
SELECT cim, tema, decode(tema,null,'***',tema) --nvl(tema,'***')
FROM konyvtar.konyv
ORDER BY tema ASC nulls first;

--36. Listázzuk ki a felhasználói nevünket!
SELECT user
FROM dual;

--37. Fûzzük össze az 'alma' és a 'fa' szavakat kétféle megoldással!
SELECT 'alma' ||''|| 'fa'
FROM dual;
SELECT concat('alma','fa')
FROM dual;

--38. Listázzuk ki az 'almafa' szót nagy kezdõbetûvel!
SELECT initcap('almafa')
FROM dual;

--39. Listázzuk ki a tagok vezetéknevét, majd a tagok nevét csupa kisbetûvel, és csupa nagybetûvel!
SELECT vezeteknev, lower(vezeteknev), upper(vezeteknev)
FROM konyvtar.tag;

--40. Listázzuk ki a tagok vezetéknevét! Próbáljuk ki a substr függvény mûködését, a 3. karaktertõl kezdõdõen vegyünk 4 karaktert a vezetéknévbõl.
SELECT vezeteknev, substr(vezeteknev,3,4)
FROM konyvtar.tag;

--41. Listázzuk ki a tagok vezetékneveit! Próbáljuk ki a replace függvényt. Ha a vezetéknévben szerepel az 'er' karaktersorozat, cseréljük le 3 db *-ra.
SELECT vezeteknev, replace(vezeteknev,'er','***')
FROM konyvtar.tag;

--42. Listázzuk ki azokat a tagokat, akinek a vezetéknevében legalább két 'a' betû szerepel, mindegy, hogy kicsi vagy nagy.
SELECT *
FROM konyvtar.tag
WHERE lower(vezeteknev) like '%a%a%';

--43. Listázzuk ki a tagok születési dátumát!
SELECT to_char(szuletesi_datum,'yyyy.mm.dd. day hh24:mi:ss') AS datum --mm:9, mon:szept., month: szeptember
FROM konyvtar.tag;

--44. Írjuk ki a mai dátumot, a holnapi dátumot, az egy héttel ezelõtti dátumot és a 12 órával ezelõtti dátumot. A dátumok mellett az idõ is szerepeljen.
SELECT to_char(sysdate,'yyyy.mm.dd hh24:mi:ss'),to_char(sysdate+1,'yyyy.mm.dd hh24:mi:ss'),to_char(sysdate-7,'yyyy.mm.dd hh24:mi:ss'),to_char(sysdate-0.5,'yyyy.mm.dd hh24:mi:ss')
FROM dual;

--45. Listázzuk ki a mai dátumot, a két hónappal késõbbi dátumot és a két hónappal korábbi dátumot
SELECT to_char(sysdate,'yyyy.mm.dd hh24:mi:ss') as ma, to_char(add_months(sysdate,2),'yyyy.mm.dd hh24:mi:ss')
FROM dual;

--47. Hány nap telt el 2000 január 1 óta?
SELECT sysdate-to_date('2000.01.01.','yyyy.mm.dd.')
FROM dual;

--48. Hány év telt el 2000 január 1 óta?
SELECT (sysdate-to_date('2000.01.01.','yyyy.mm.dd.'))/12
FROM dual;

--49. Kik a 30 évnél fiatalabb tagok?
SELECT vezeteknev, keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd') as szuletesi_datum
FROM konyvtar.tag
WHERE months_between(sysdate,szuletesi_datum)/12<30;

--50. Melyek azok a tagok, akik 2000.01.01 elõtt születtek és akiknek a besorolása nyugdídjas, vagy felnõtt?
SELECT vezeteknev, keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd') as szuletesidatum
FROM konyvtar.tag
WHERE szuletesi_datum<to_date('2000.01.01.','yyyy.mm.dd.') and besorolas in ('nyugdíjas', 'felnõtt');

--51. Melyek azok a tagok, akiknek a címében szerepel az 'út' szó, vagy a nevükben pontosan két 'e' betû szerepel? A lista legyen név szerint rendezve.
SELECT *
FROM konyvtar.tag
WHERE lower(cim) LIKE '%út%' or (lower(vezeteknev ||''|| keresztnev) LIKE '%e%e%' and lower(vezeteknev ||''|| keresztnev) not like '%e%e%e%')
ORDER BY vezeteknev ASC, keresztnev ASC;

--53. Azokat a tagokat keressük, akinek a nevében legalább kettõ 'e' betû szerepel és igaz rájuk, hogy 40 évnél fiatalabbak vagy besorolásuk gyerek.
SELECT *
FROM konyvtar.tag
WHERE lower(vezeteknev ||''|| keresztnev) LIKE '%e%e%' and (besorolas='gyerek' or month_between(sysdate,szuletesi_datum)/12<40);
/*
********************MATEMATIKAI FÜGGVÉNYEK ********************
KEREKÍTÉSRE HASZNÁLANDÓ FÜGGVÉNYEK
trunc(): Ha kisebb mint, 0 akkor levágja az elejét és 1-et ad vissza. Levágja a számok egész értékét alapból, de meg lehet adni, hogy hány tizedesjegyig menjen.
round(): Matematika szabályai szerint kerekít. Alapból 0 tizedesjegyre kerekít. Pontosabb.

MÛVELETI FÜGGVÉNY
abs(): Az elemek abszolút értékét adja vissza
sqrt(): Négyzetgyök függvény

********************SZÖVEG FÜGGVÉNYEK ********************
length(''): Megadja, hány karakter hosszú az adott kifejezés
instr('',''): Visszaadja, hogy a második argumentumként megadott kifejezés, hanyadik karaktertõl kezdõdik, az 1. argumentúban
||' '||: Összefûz több kifejezést
concat(): Összefûz két kifejezést
initcap(): A beleírt kifejezést nagy kezdõbetûvel kezdi el
lower(): Csupa kisbetûvel írja ki a beleírt kifejezést
upper(): Csupa nagybetûvel írja ki a beleírt kifejezést
substr(kifejezes,honnan,mennyit): Visszaad egy adott tartományt a megadott kifejezésbõl
replace(honnan,mit,mire): Egy adott kifejezésben, ha szerepel a 2. argumentumban megadott kifejezés, akkor kicseréli a 3. argumentumban lévõ kifejezésre
hol like '%a%a%': Visszaadja azokat az értékeket, amikben 2 db a betû szerepel
to_char(): Meg lehet benne adni, hogy egy kifejezés, milyen formátumban szeretnénk visszakapni

************************FELTÉTELES FÜGGVÉNY***********************
decode(oszlop_nev,'ha 1','írja ezt ki','ha 2','akkor írja ezt ki','különben ezt')
nvl(mit_cseréljen,'erre cserélje'): Ha null értéket, talál akkor kicseréli a 2. argumentumra

************************IDÕ FÜGGVÉNY***********************
sysdate: aktuális dátum
sysdate+1: 1 nappal késõbbi dátum
add_months(sysdate,2): Hozzáadja a dátumhoz a 2. argumentumban megadott számnyi hónapot
to_date('2000.01.01.','yyyy.mm.dd.'): átalakítás dátum formátumba
months_between(sysdate,szuletesi_datum): Hány hónap telt el a két dátumm között
************************OPERÁTOROK***********************
%: bármennyi karakter lehet közöttük
?: adott helyen szerepel egy karakter
_: 1 karakter elõfordulására jó
*/