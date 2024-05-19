--Nézettáblák, szekvenciák, szinonímák
--Javító Zh: Május 28: 12-14, akik javítani akarnak, azoknak nem kell bejönni a 2.zh-ra
--Nézettábla--------------------------------------------------------------
--Nézet: Virtuális táblát hoz létre, csak azokat az oszlopokat lehet látni, amik meg vannak adva
/* Minta feladat
193. Hozzunk létre nézetet v_szerzo_konyv néven, amelyben azt listázzuk, hogy az egyes könyveknek kik a szerzõi. A lista csak azokat a könyveket
tartalmazza, amelyeknek van szerzõje. A lista tartalmazza a könyvek oldalankénti árát is.
*/
DROP VIEW v_szerzo_konyv;

CREATE VIEW v_szerzo_konyv AS 
SELECT kk.cim, ksz.vezeteknev, ksz.keresztnev, kk.ar/kk.oldalszam ar
FROM konyvtar.konyv kk INNER JOIN konyvtar.konyvszerzo ko ON kk.konyv_azon = ko.konyv_azon INNER JOIN konyvtar.szerzo ksz ON ksz.szerzo_azon=ko.szerzo_azon
WHERE ko.szerzo_azon is not null;

SELECT *
FROM v_szerzo_konyv;

/*
194. Hozzunk létre nézete, amely a horror, sci-fi, krimi témájú könyvek címét, leltári számát és oldalankénti árát listázza.
*/
CREATE VIEW v_felos_konyvek AS
SELECT kk.cim, kv.leltari_szam, kk.ar/kk.oldalszam ar_per_oldal
FROM konyvtar.konyv kk INNER JOIN konyvtar.konyvtari_konyv kv ON kk.konyv_azon = kv.konyv_azon
WHERE tema in ('krimi', 'sci-fi', 'horror');

SELECT *
FROM v_felos_konyvek;

--Szekvencia---------------------------------------------------------------
--Egyedi számok lehet vele generálni. A számok tudnak egy adott lépésközzel növekedni és csökkenni

--szekvencia, amely 1000 indul, 10-esével növekszik

CREATE SEQUENCE az1000es
START WITH 1000
INCREMENT BY 10;

SELECT  az1000es.nextval
FROM dual;

--Szinonímák-----------------------------------------------------
--Másik objektumra mutató nevek. Nem kell megadni az objektum teljes nevét, csak a szinonímát

--DCL utasítások: Jogosultságok és jogosultság kezelés---------------------------------------------------------
--GRANT: Jogosultság adás
/*
GRANT [<JOG>,... | ALL [PRIVILEGES]] milyen jogokat szeretnénk megadni a felhasználónak
TO [<felhasználónév> | PUBLIC]
[with ADMIN OPTION | WITH GRANT OPTION]
Rendszerjogoknál a PRIVILEGES kötelezõ
Objektumjogoknál elhagyható
    Általában táblához, nézethez adjuk
Egyszerre csak egyféle jogot használhatunk keverni nem lehet
GRANT [<OSZLOP>] [ON <objektum>]
TO [<felhasználónév> | PUBLIC]
[with ADMIN OPTION | WITH GRANT OPTION]
*/
--REVOKE: Jogosultság visszavonása
/*
REVOKE [<JOG>,... | ALL [PRIVILEGES]]  [ON <objektum>]
FROM [<felhasználónév>,... | PUBLIC]
[CASCADE CONSTRAINTS]
*/


--hozzunk létre szinonímát a tag táblára k_tag néven
CREATE SYNONYM k_tag
FOR konyvtar.tag;

SELECT *
FROM k_tag;

--lekérdezési jogosultság x-nek a sajat_konyv táblára
CREATE USER X;
CREATE TABLE sajat_konyv as 
SELECT *
FROM konyvtar.konyv;

GRANT 
SELECT ON sajat_konyv
TO X;
--Visszavonás
REVOKE 
SELECT ON sajat_konyv
FROM X;

--lekérdezési és beszúrási jog x-nek a saját könyvre és engedélyezzük, hogy tovább adhassa
GRANT 
SELECT, INSERT ON sajat_konyv
TO X
WITH GRANT OPTION;

--visszavonás
REVOKE 
SELECT, INSERT ON sajat_konyv
FROM X;-- így csak x-tõl vonja meg, de azoktól nem akik továbbadta

--visszavonás a továbbadottaktól
REVOKE 
SELECT, INSERT ON sajat_konyv
FROM X CASCADE CONSTRAINTS;

--törlés: delete

--Hivatkozási jogosultság
GRANT
REFERENCES ON sajat_konyv
TO X;

--visszavonás
REVOKE
REFERENCES ON sajat_konyv
FROM X;

--Módosítási jogosultság
GRANT
UPDATE ON sajat_konyv
TO X;

--visszavonás
REVOKE
UPDATE ON sajat_konyv
FROM X;

--hivatkozási jogosultság a konyv_azon oszlopra
GRANT 
REFERENCES (konyv_azon) ON sajat_konyv
TO X;
--Visszavonni sajnos oszlopra adott jogot nem lehet

--Adjunk mindenféle jogosultságot mindenkinek
GRANT
ALL PRIVILEGES ON sajat_konyv
TO PUBLIC;
--REVOKE-OT NE HASZNÁLD!!!
