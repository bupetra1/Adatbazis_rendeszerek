--------------------------------------------------------------1. feladat: outer join haszn�lata----------------------------------------------------------------------------------------------

--140. List�zzuk a PARK K�NYVKIAD� KFT. �s a EUR�PA K�NYVKIAD� KFT. kiad�j� k�nyvek �sszes k�nyv�nek azonos�t�j�t, �s ha van hozz�
--p�ld�ny, akkor annak a lelt�ri sz�m�t.
SELECT kkv.konyv_azon, kkv.leltari_szam
FROM konyvtar.konyvtari_konyv kkv FULL OUTER JOIN konyvtar.konyv kv ON kkv.konyv_azon=kv.konyv_azon
WHERE kv.kiado IN ('PARK K�NYVKIAD� KFT.', 'EUR�PA K�NYVKIAD� KFT.');

----------------------------------------------------------------2. feladat: exists haszn�lata----------------------------------------------------------------------------------------------

--156. Keress�k azokat a tagokat, akiknek van k�lcs�nz�s�k.
SELECT *
FROM KONYVTAR.TAG t
WHERE EXISTS (
SELECT 1
FROM konyvtar.kolcsonzes k
WHERE t.olvasojegyszam=k.tag_azon);

--List�zza ki azoknak a k�nyveknek az  azonos�t�j�t, amelyek�rt t�bbet fizettek, mint a 2010 augusztus�ban kiadott k�nyvek k�z�l b�rmelyik�rt.
--A k�nyvek azonos�t�ja mellett t�ntesse fel a fizetett �sszeget is.
SELECT konyv_azon, ar
FROM konyvtar.konyv
WHERE ar> ALL(
SELECT ar
FROM konyvtar.konyv
WHERE to_char(kiadas_datuma, 'yyyy.mm') LIKE '2010.08');

--List�zza ki azoknak a k�nyveknek az  azonos�t�j�t, amelyekben ugyanannyi oldal van, mint valamelyik 2010 augusztus�ban kiadott k�nyvben.
--A k�nyvek azonos�t�ja mellett t�ntesse fel a fizetett �sszeget is.
SELECT konyv_azon, oldalszam
FROM konyvtar.konyv
WHERE oldalszam = ANY (
SELECT oldalszam
FROM konyvtar.konyv
WHERE to_char(kiadas_datuma, 'yyyy.mm') LIKE '2010.08');

----------------------------------------------------------------2. feladat: Halmaz m�veletek haszn�lata----------------------------------------------------------------------------------------------

--168. Melyek azok a keresztnevek, amelyek szerz� keresztneve is �s egyben valamelyik tag� is.
SELECT t.keresztnev
FROM KONYVTAR.TAG t
INTERSECT
SELECT sz.keresztnev
FROM KONYVTAR.SZERZO sz;

--167. List�zzuk egy list�ban a szerz�k keresztnev�t �s sz�let�si h�napj�t illetve a tagok keresztnev�t �s sz�let�si h�napj�t. Minden n�v, h�nap p�ros csak
--egyszer szerepeljen.
SELECT sz.keresztnev, to_char(sz.szuletesi_datum ,'mm')
FROM KONYVTAR.SZERZO sz
UNION
SELECT t.keresztnev, to_char(t.szuletesi_datum ,'mm')
FROM KONYVTAR.TAG t;

--169. Melyek azok a keresztnevek, amelyek valamelyik szerz� keresztneve, de egyetlen tag� sem?
SELECT sz.keresztnev
FROM KONYVTAR.SZERZO sz
MINUS
SELECT t.keresztnev
FROM KONYVTAR.TAG t;

--164. List�zzuk ki az els� 10 legdr�g�bb k�nyvet.
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

----------------------------------------------------------------2. feladat: T�bla kezel� m�veletek haszn�lata----------------------------------------------------------------------------------------------
/*173. Hozzunk l�tre t�bl�t szemely n�ven a k�vetkez� oszlopokkal:
azon: max. 5 sz�mjegy� eg�sz sz�m,
nev: maximum 30 hossz� v�ltoz� hossz�s�g� karaktersorozat, amelyet ki kell t�lteni,
szul_dat: d�tum t�pus�,
irsz: pontosan 4 karakter hossz� sztring,
cim: maximum 40 hossz� v�ltoz� hossz�s�g� karaktersorozat,
zsebpenz: sz�m, amelynek maximum 12 sz�mjegye lehet, amelyb�l az utols� kett� a tizedesvessz� ut�n �ll.
A t�bla els�dleges kulcsa az azon oszlop legyen. A nev, szul_dat, cim egy�tt legyen egyedi. A zsebpenz, ha ki van t�ltve, legyen nagyobb, mint 100.*/
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

/*175. Hozzunk l�tre t�bl�t bicikli n�ven a k�vetkez� oszlopokkal:
azon: max. 5 sz�mjegy� eg�sz sz�m,
szin: maximum 20 hossz� v�ltoz� hossz�s�g� karaktersorozat,
tulaj_azon: max. 5 sz�mjegy� eg�sz sz�m.
A t�bla els�dleges kulcsa az azon oszlop legyen. A tulaj_azon hivatkozzon a szem�ly t�bla els�dleges kulcs�ra.*/
CREATE TABLE bicikli(
azon NUMBER(5),
szin VARCHAR2(20),
tulaj_azon NUMBER(5),
CONSTRAINT bicikli_pk PRIMARY KEY (azon),
CONSTRAINT bicikli_fk FOREIGN KEY (tulaj_azon) REFERENCES szemely_sok(azon));

--182. Adjuk a bicikli t�bl�hoz �j oszlopot tipus n�vvel �s maximum 30 hossz� v�ltoz� hossz�s�g� karaktersorozattal
ALTER TABLE bicikli
ADD (tipus VARCHAR2(30));

--183. Dobjuk el a bicikli t�bla tipus oszlop�t!
ALTER TABLE bicikli
DROP COLUMN tipus;

----182. Adjuk a bicikli t�bl�hoz �j oszlopot tipus n�vvel �s maximum 30 hossz� v�ltoz� hossz�s�g� karaktersorozattal �s adjuk meg az ismeretlen-t alap�rt�kk�nt
ALTER TABLE bicikli
ADD (tipus VARCHAR2(30) default 'ismeretlen');

--197. N�velj�k meg azon szerz�k honor�rium�t az �ltaluk �rt k�nyv �r�nak a 10-szeres�vel, akik 1900 ut�n sz�lettek.
update konyvszerzo ksz
set honorarium=honorarium+(select ar*10
 from konyvtar.konyv ko
 where ksz.konyv_azon=ko.konyv_azon)
where szerzo_azon in (select szerzo_azon
 from konyvtar.szerzo
 where szuletesi_datum>to_date('1900','yyyy'));
commit; 

--198. T�r�lj�k azokat a k�nyveket, amelyekhez nincs p�ld�ny.
CREATE TABLE konyv AS
SELECT *
FROM konyvtar.konyv;

DELETE FROM konyv
WHERE konyv_azon not in (
SELECT konyv_azon 
FROM konyvtar.konyvtari_konyv);
Commit;

--195. Hozzunk l�tre n�zetet legidosebb_szerzo n�ven, amely a legid�sebb szerz� nev�t �s sz�let�si d�tum�t list�zza.
CREATE VIEW legidosebb_szerzo AS
SELECT sz.vezeteknev ||' '|| sz.keresztnev nev, sz.szuletesi_datum
FROM konyvtar.szerzo sz
WHERE sz.szuletesi_datum = (
SELECT min(szuletesi_datum)
FROM konyvtar.szerzo);

