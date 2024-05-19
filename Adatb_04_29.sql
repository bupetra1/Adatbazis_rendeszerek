--N�zett�bl�k, szekvenci�k, szinon�m�k
--Jav�t� Zh: M�jus 28: 12-14, akik jav�tani akarnak, azoknak nem kell bej�nni a 2.zh-ra
--N�zett�bla--------------------------------------------------------------
--N�zet: Virtu�lis t�bl�t hoz l�tre, csak azokat az oszlopokat lehet l�tni, amik meg vannak adva
/* Minta feladat
193. Hozzunk l�tre n�zetet v_szerzo_konyv n�ven, amelyben azt list�zzuk, hogy az egyes k�nyveknek kik a szerz�i. A lista csak azokat a k�nyveket
tartalmazza, amelyeknek van szerz�je. A lista tartalmazza a k�nyvek oldalank�nti �r�t is.
*/
DROP VIEW v_szerzo_konyv;

CREATE VIEW v_szerzo_konyv AS 
SELECT kk.cim, ksz.vezeteknev, ksz.keresztnev, kk.ar/kk.oldalszam ar
FROM konyvtar.konyv kk INNER JOIN konyvtar.konyvszerzo ko ON kk.konyv_azon = ko.konyv_azon INNER JOIN konyvtar.szerzo ksz ON ksz.szerzo_azon=ko.szerzo_azon
WHERE ko.szerzo_azon is not null;

SELECT *
FROM v_szerzo_konyv;

/*
194. Hozzunk l�tre n�zete, amely a horror, sci-fi, krimi t�m�j� k�nyvek c�m�t, lelt�ri sz�m�t �s oldalank�nti �r�t list�zza.
*/
CREATE VIEW v_felos_konyvek AS
SELECT kk.cim, kv.leltari_szam, kk.ar/kk.oldalszam ar_per_oldal
FROM konyvtar.konyv kk INNER JOIN konyvtar.konyvtari_konyv kv ON kk.konyv_azon = kv.konyv_azon
WHERE tema in ('krimi', 'sci-fi', 'horror');

SELECT *
FROM v_felos_konyvek;

--Szekvencia---------------------------------------------------------------
--Egyedi sz�mok lehet vele gener�lni. A sz�mok tudnak egy adott l�p�sk�zzel n�vekedni �s cs�kkenni

--szekvencia, amely 1000 indul, 10-es�vel n�vekszik

CREATE SEQUENCE az1000es
START WITH 1000
INCREMENT BY 10;

SELECT  az1000es.nextval
FROM dual;

--Szinon�m�k-----------------------------------------------------
--M�sik objektumra mutat� nevek. Nem kell megadni az objektum teljes nev�t, csak a szinon�m�t

--DCL utas�t�sok: Jogosults�gok �s jogosults�g kezel�s---------------------------------------------------------
--GRANT: Jogosults�g ad�s
/*
GRANT [<JOG>,... | ALL [PRIVILEGES]] milyen jogokat szeretn�nk megadni a felhaszn�l�nak
TO [<felhaszn�l�n�v> | PUBLIC]
[with ADMIN OPTION | WITH GRANT OPTION]
Rendszerjogokn�l a PRIVILEGES k�telez�
Objektumjogokn�l elhagyhat�
    �ltal�ban t�bl�hoz, n�zethez adjuk
Egyszerre csak egyf�le jogot haszn�lhatunk keverni nem lehet
GRANT [<OSZLOP>] [ON <objektum>]
TO [<felhaszn�l�n�v> | PUBLIC]
[with ADMIN OPTION | WITH GRANT OPTION]
*/
--REVOKE: Jogosults�g visszavon�sa
/*
REVOKE [<JOG>,... | ALL [PRIVILEGES]]  [ON <objektum>]
FROM [<felhaszn�l�n�v>,... | PUBLIC]
[CASCADE CONSTRAINTS]
*/


--hozzunk l�tre szinon�m�t a tag t�bl�ra k_tag n�ven
CREATE SYNONYM k_tag
FOR konyvtar.tag;

SELECT *
FROM k_tag;

--lek�rdez�si jogosults�g x-nek a sajat_konyv t�bl�ra
CREATE USER X;
CREATE TABLE sajat_konyv as 
SELECT *
FROM konyvtar.konyv;

GRANT 
SELECT ON sajat_konyv
TO X;
--Visszavon�s
REVOKE 
SELECT ON sajat_konyv
FROM X;

--lek�rdez�si �s besz�r�si jog x-nek a saj�t k�nyvre �s enged�lyezz�k, hogy tov�bb adhassa
GRANT 
SELECT, INSERT ON sajat_konyv
TO X
WITH GRANT OPTION;

--visszavon�s
REVOKE 
SELECT, INSERT ON sajat_konyv
FROM X;-- �gy csak x-t�l vonja meg, de azokt�l nem akik tov�bbadta

--visszavon�s a tov�bbadottakt�l
REVOKE 
SELECT, INSERT ON sajat_konyv
FROM X CASCADE CONSTRAINTS;

--t�rl�s: delete

--Hivatkoz�si jogosults�g
GRANT
REFERENCES ON sajat_konyv
TO X;

--visszavon�s
REVOKE
REFERENCES ON sajat_konyv
FROM X;

--M�dos�t�si jogosults�g
GRANT
UPDATE ON sajat_konyv
TO X;

--visszavon�s
REVOKE
UPDATE ON sajat_konyv
FROM X;

--hivatkoz�si jogosults�g a konyv_azon oszlopra
GRANT 
REFERENCES (konyv_azon) ON sajat_konyv
TO X;
--Visszavonni sajnos oszlopra adott jogot nem lehet

--Adjunk mindenf�le jogosults�got mindenkinek
GRANT
ALL PRIVILEGES ON sajat_konyv
TO PUBLIC;
--REVOKE-OT NE HASZN�LD!!!
