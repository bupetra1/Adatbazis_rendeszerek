--1. Listázza ki a 15 tonnát meghaladó rakománnyal rendelkezõ konténerek teljes azonosítóját
--(megrendelésazonosító és konténerazonosító), valamint a rakománysúlyát is 2 tizedesjegyre
--kerekítve! Rendezze az eredményt a pontos rakománysúly szerint növekvõ sorrendbe
SELECT sh.megrendeles, sh.kontener, ROUND(sh.rakomanysuly,2) AS SULY
FROM HAJO.s_hozzarendel sh
WHERE sh.rakomanysuly>15
ORDER BY SULY ASC;

--2.Listázza ki a kis méretû, mobil darukkal rendelkezõ kikötõk adatait! Ezeknek a kikötõknek
--a leírásában megtalálható a 'kikötõméret: kicsi', illetve a 'mobil daruk' sztring (nem feltétlenül
--ebben a sorrendben)
SELECT *
FROM HAJO.s_kikoto sk
WHERE sk.leiras LIKE '%kikötõméret: kicsi%' AND sk.leiras LIKE '%mobil daruk%';

--3.Listázza ki azoknak az utasoknak az adatait (a dátumokat idõponttal együtt!), amelyek
--nem egész percben indultak! Rendezze az eredményt az indulási idõ szerint növekvõ sorrendbe
SELECT su.ugyfel_id, to_char(sm.megrendeles_datuma, 'yyyy.mm.dd hh24:mi:ss') AS MEGRENDELES_DATUMA, su.vezeteknev ||' '|| su.keresztnev AS NEV, su.telefon, su.email, to_char(su.szul_dat,'yyyy.mm.dd hh24:mi:ss') AS SZUL_DATE, su.helyseg, su.utca_hsz
FROM HAJO.s_megrendeles sm INNER JOIN HAJO.s_ugyfel su ON sm.ugyfel = su.ugyfel_id
WHERE to_char(sm.megrendeles_datuma, 'mi:ss') NOT LIKE '__:00'
ORDER BY MEGRENDELES_DATUMA ASC;

--4. Hány 500 tonnánál nagyobb maximális súlyterhelésû hajó tartozik az egyes hajútípusokhoz?
--A hajótípusokat az azonosítójukkal adja meg
SELECT sh.hajo_tipus, count(sh.hajo_id) AS DB
FROM HAJO.s_hajo sh
WHERE sh.max_sulyterheles>500
GROUP BY sh.hajo_tipus;

--5. Mely hónapokban (év, hónap) adtak le legalább 6 megrendelést? A lista legyen idõrendben
SELECT to_char(sm.megrendeles_datuma,'yyyy') AS EV , to_char(sm.megrendeles_datuma,'mm') AS HONAP, COUNT(sm.megrendeles_id) AS DB
FROM HAJO.s_megrendeles sm
GROUP BY to_char(sm.megrendeles_datuma,'yyyy') , to_char(sm.megrendeles_datuma,'mm')
HAVING COUNT(sm.megrendeles_id)>=6
ORDER BY to_char(sm.megrendeles_datuma,'yyyy'),  to_char(sm.megrendeles_datuma,'mm') ;

--6. Listázza ki a szírii ügyfelek teljes nevét és telefonszámát!
SELECT su.vezeteknev ||' '|| su.keresztnev AS NEV, su.telefon
FROM HAJO.s_ugyfel su INNER JOIN HAJO.s_helyseg sh ON su.helyseg=sh.helyseg_id
WHERE sh.orszag LIKE 'Szíria';

--7. Mennyi az egyes hajótípusokhoz tartozó hajók legkisebb nettó súlya?
--A hajótípusokat a nevükkel adja meg! Csak azokat a hajótípusokat listázza, amelyekhez van hajónk!
SELECT sht.nev, MIN(sh.netto_suly) AS NETTO_SULY
FROM HAJO.s_hajo sh INNER JOIN HAJO.s_hajo_tipus sht ON sh.hajo_tipus = sht.hajo_tipus_id
GROUP BY sht.nev;


--8. Melyik ázsiai településeken található kikötõ? Az eredményben az ország- és helységneveket adja meg,
--országnév, azon bellül helységnév szerint rendezve!
SELECT sh.orszag, sh.helysegnev
FROM HAJO.s_kikoto sk INNER JOIN HAJO.s_helyseg sh ON sk.helyseg=sh.helyseg_id INNER JOIN HAJO.s_orszag so ON sh.orszag= so.orszag
WHERE so.foldresz LIKE 'Ázsia'
ORDER BY sh.orszag, sh.helysegnev;

--9. Melyik hajó(k) indult(ak) útra utoljára? Listázza ki ezeknek a hajóknak a nevét, azonosítóját
--az indulási és érkezési kikötõk azonosítóját, valamint az indulás dátumát és idõpontját.
SELECT sh.nev, sh.hajo_id, su.indulasi_kikoto, su.erkezesi_kikoto, to_char(su.indulasi_ido, 'yyyy.mm.dd') AS DATUM, to_char(su.indulasi_ido, 'hh24:mi:ss') AS IDO
FROM HAJO.s_ut su INNER JOIN HAJO.s_hajo sh ON su.hajo=sh.hajo_id
WHERE su.indulasi_ido in (
SELECT min(indulasi_ido)
FROM HAJO.s_ut);

--10. Az 'It_Cat' azonosítójú kikötõbõl induló legkorábbi út/utak melyik kikötõ(k)be szállítottak?
--Adja meg az érkezési kikötõ(k) azonosítóját, valamint a helységeknek és országoknak a nevét
SELECT s.erkezesi_kikoto, sh.orszag, sh.helysegnev
FROM HAJO.s_ut s INNER JOIN HAJO.s_kikoto sk ON s.indulasi_kikoto=sk.kikoto_id INNER JOIN HAJO.s_helyseg sh ON sk.helyseg = sh.helyseg_id
WHERE s.indulasi_ido in(
SELECT min(su.indulasi_ido)
FROM HAJO.s_ut su
WHERE su.indulasi_kikoto LIKE 'It_Cat');