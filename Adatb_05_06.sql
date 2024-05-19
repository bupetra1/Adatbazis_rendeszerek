--------------------------------------------------------------1. feladat: outer join használata----------------------------------------------------------------------------------------------

--140. Listázzuk a PARK KÖNYVKIADÓ KFT. és a EURÓPA KÖNYVKIADÓ KFT. kiadójú könyvek összes könyvének azonosítóját, és ha van hozzá
--példány, akkor annak a leltári számát.
SELECT kkv.konyv_azon, kkv.leltari_szam
FROM konyvtar.konyvtari_konyv kkv FULL OUTER JOIN konyvtar.konyv kv ON kkv.konyv_azon=kv.konyv_azon
WHERE kv.kiado IN ('PARK KÖNYVKIADÓ KFT.', 'EURÓPA KÖNYVKIADÓ KFT.');

----------------------------------------------------------------2. feladat: exists használata----------------------------------------------------------------------------------------------

--156. Keressük azokat a tagokat, akiknek van kölcsönzésük.
SELECT *
FROM KONYVTAR.TAG t
WHERE EXISTS (
SELECT 1
FROM konyvtar.kolcsonzes k
WHERE t.olvasojegyszam=k.tag_azon);

--Listázza ki azoknak a könyveknek az  azonosítóját, amelyekért többet fizettek, mint a 2010 augusztusában kiadott könyvek közül bármelyikért.
--A könyvek azonosítója mellett tüntesse fel a fizetett összeget is.
SELECT konyv_azon, ar
FROM konyvtar.konyv
WHERE ar> ALL(
SELECT ar
FROM konyvtar.konyv
WHERE to_char(kiadas_datuma, 'yyyy.mm') LIKE '2010.08');

--Listázza ki azoknak a könyveknek az  azonosítóját, amelyekben ugyanannyi oldal van, mint valamelyik 2010 augusztusában kiadott könyvben.
--A könyvek azonosítója mellett tüntesse fel a fizetett összeget is.
SELECT konyv_azon, oldalszam
FROM konyvtar.konyv
WHERE oldalszam = ANY (
SELECT oldalszam
FROM konyvtar.konyv
WHERE to_char(kiadas_datuma, 'yyyy.mm') LIKE '2010.08');

----------------------------------------------------------------2. feladat: Halmaz mûveletek használata----------------------------------------------------------------------------------------------

--168. Melyek azok a keresztnevek, amelyek szerzõ keresztneve is és egyben valamelyik tagé is.
SELECT t.keresztnev
FROM KONYVTAR.TAG t
INTERSECT
SELECT sz.keresztnev
FROM KONYVTAR.SZERZO sz;

--167. Listázzuk egy listában a szerzõk keresztnevét és születési hónapját illetve a tagok keresztnevét és születési hónapját. Minden név, hónap páros csak
--egyszer szerepeljen.
SELECT sz.keresztnev, to_char(sz.szuletesi_datum ,'mm')
FROM KONYVTAR.SZERZO sz
UNION
SELECT t.keresztnev, to_char(t.szuletesi_datum ,'mm')
FROM KONYVTAR.TAG t;

--169. Melyek azok a keresztnevek, amelyek valamelyik szerzõ keresztneve, de egyetlen tagé sem?
SELECT sz.keresztnev
FROM KONYVTAR.SZERZO sz
MINUS
SELECT t.keresztnev
FROM KONYVTAR.TAG t;

--164. Listázzuk ki az elsõ 10 legdrágább könyvet.
SELECT *
FROM (
SELECT* 
FROM konyvtar.konyv
ORDER BY ar DESC NULLS  LAST)
WHERE rownum<11;

SELECT * 
FROM konyvtar.konyv
ORDER BY ar DESC NULLS  LAST
FETCH FIRST 10 ROWS ONLY;

----------------------------------------------------------------2. feladat: Tábla kezelõ mûveletek használata----------------------------------------------------------------------------------------------
/*173. Hozzunk létre táblát szemely néven a következõ oszlopokkal:
azon: max. 5 számjegyû egész szám,
nev: maximum 30 hosszú változó hosszúságú karaktersorozat, amelyet ki kell tölteni,
szul_dat: dátum típusú,
irsz: pontosan 4 karakter hosszú sztring,
cim: maximum 40 hosszú változó hosszúságú karaktersorozat,
zsebpenz: szám, amelynek maximum 12 számjegye lehet, amelybõl az utolsó kettõ a tizedesvesszõ után áll.
A tábla elsõdleges kulcsa az azon oszlop legyen. A nev, szul_dat, cim együtt legyen egyedi. A zsebpenz, ha ki van töltve, legyen nagyobb, mint 100.*/
DROP TABLE szemely_sok;
CREATE TABLE szemely_sok(
azon NUMBER(5),
nev VARCHAR2(30) NOT NULL,
szul_dat DATE,
irsz VARCHAR(4),
cim VARCHAR(40),
zsebpenz NUMBER(12,2),
CONSTRAINT szemely_sok_pk PRIMARY KEY (azon),
CONSTRAINT szemely_sok_uq UNIQUE (nev, szul_dat, cim),
CONSTRAINT szemely_sok_ck CHECK (zsebpenz > 100));

/*175. Hozzunk létre táblát bicikli néven a következõ oszlopokkal:
azon: max. 5 számjegyû egész szám,
szin: maximum 20 hosszú változó hosszúságú karaktersorozat,
tulaj_azon: max. 5 számjegyû egész szám.
A tábla elsõdleges kulcsa az azon oszlop legyen. A tulaj_azon hivatkozzon a személy tábla elsõdleges kulcsára.*/
CREATE TABLE bicikli(
azon NUMBER(5),
szin VARCHAR2(20),
tulaj_azon NUMBER(5),
CONSTRAINT bicikli_pk PRIMARY KEY (azon),
CONSTRAINT bicikli_fk FOREIGN KEY (tulaj_azon) REFERENCES szemely_sok(azon));

--182. Adjuk a bicikli táblához új oszlopot tipus névvel és maximum 30 hosszú változó hosszúságú karaktersorozattal
ALTER TABLE bicikli
ADD (tipus VARCHAR2(30));

--183. Dobjuk el a bicikli tábla tipus oszlopát!
ALTER TABLE bicikli
DROP COLUMN tipus;

----182. Adjuk a bicikli táblához új oszlopot tipus névvel és maximum 30 hosszú változó hosszúságú karaktersorozattal és adjuk meg az ismeretlen-t alapértékként
ALTER TABLE bicikli
ADD (tipus VARCHAR2(30) default 'ismeretlen');

--197. Növeljük meg azon szerzõk honoráriumát az általuk írt könyv árának a 10-szeresével, akik 1900 után születtek.
update konyvszerzo ksz
set honorarium=honorarium+(select ar*10
 from konyvtar.konyv ko
 where ksz.konyv_azon=ko.konyv_azon)
where szerzo_azon in (select szerzo_azon
 from konyvtar.szerzo
 where szuletesi_datum>to_date('1900','yyyy'));
commit; 

--198. Töröljük azokat a könyveket, amelyekhez nincs példány.
CREATE TABLE konyv AS
SELECT *
FROM konyvtar.konyv;

DELETE FROM konyv
WHERE konyv_azon not in (
SELECT konyv_azon 
FROM konyvtar.konyvtari_konyv);
Commit;

--195. Hozzunk létre nézetet legidosebb_szerzo néven, amely a legidõsebb szerzõ nevét és születési dátumát listázza.
CREATE VIEW legidosebb_szerzo AS
SELECT sz.vezeteknev ||' '|| sz.keresztnev nev, sz.szuletesi_datum
FROM konyvtar.szerzo sz
WHERE sz.szuletesi_datum = (
SELECT min(szuletesi_datum)
FROM konyvtar.szerzo);

