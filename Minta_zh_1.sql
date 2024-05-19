--1. Listázza ki a 7 és 14 tonna közé esõ rakománnyal rendelkezõ konténerek teljes azonosítóját
--megrendelésazonosító és konténerazonosító), valamint a rakománysúlyt is 2 
--tizedesjegyre kerekítve. Rendezze az eredményt a pontos rakománysúly szerint csökkenõ sorrendbe!
SELECT h.megrendeles, h.kontener, ROUND(h.rakomanysuly,2) AS rakomanysuly
FROM HAJO.s_hozzarendel h
WHERE h.rakomanysuly between 7 and 14
ORDER BY h.rakomanysuly DESC;

--2. Listázza ki azoknak az ügyfeleknek a teljes nevét "<vezetéknév>, <keresztnév>" formátumban
--(azaz a keresztnevet egy vesszõvel és egy szóközzel válassza el a vezetéknévtõl),
--akikrõl nem tudjuk, melyik településen laknak, de azt igen, hogy a keresztnevük
-- 5 karakterbõl áll! A lista legyen vezetéknév alapján csökkenõ sorrendbe rendezve
SELECT u.vezeteknev ||', '|| u.keresztnev AS nev
FROM HAJO.s_ugyfel u
WHERE u.helyseg IS NULL AND u.keresztnev LIKE '_____'
ORDER BY u.vezeteknev DESC;

--3. Listázza ki a 2021 februárjában és áprilisában leadott megrendelések dátumát és idõpontját
--az indulási, és érkezési kikötõk azonosítóját, valamint a fizetett összeget, ez utóbbi szerint
--csökkenõ sorrendben
SELECT to_char(m.megrendeles_datuma,'yyyy.mm.dd') AS MEGRENDELES_DATUMA, to_char(m.megrendeles_datuma, 'hh24:mi:ss') AS MEGRENDELES_IDEJE,m.indulasi_kikoto, m.erkezesi_kikoto, m.fizetett_osszeg
FROM HAJO.s_megrendeles m
WHERE to_char(m.megrendeles_datuma,'yyyy.mm.dd') LIKE '2021.02.__' OR to_char(m.megrendeles_datuma,'yyyy.mm.dd') LIKE '2021.04.__' 
ORDER BY m.fizetett_osszeg DESC;

--4. Mekkora az egyes földrészek területe (a földrészen található országok területének az összege)
--Rendezze az eredményt területek szerint csökkenõ sorrendbe!
--A nem ismerrt földrész ne jelenjen meg a listában
SELECT o.foldresz, sum(o.terulet) AS terulet
FROM HAJO.s_orszag o
WHERE o.foldresz NOT LIKE 'nem ismert földrész'
GROUP BY o.foldresz;

--5. Mely ügyfelek rendeltek összesen legalább 10 millió értékben, és mekkora ez az érték?
--Az ügyfeleket az azonosítójukkal adja meg
SELECT m.ugyfel, sum(m.fizetett_osszeg) AS osszeg
FROM HAJO.s_megrendeles m
GROUP BY m.ugyfel
HAVING sum(m.fizetett_osszeg)>=10000000;

--6. Listázza ki azoknak a hajótípusoknak a nevét, amilyen típusú hajókkal rendelkezik a cégünk.
--Egy típusnév csak egyszer szerepeljen az eredményben!
SELECT DISTINCT sht.nev
FROM HAJO.s_hajo sh INNER JOIN HAJO.s_hajo_tipus sht ON sh.hajo_tipus = sht.hajo_tipus_id;

--7. Adja meg, hogy az egyes hónapokban (év, hónap) hány olyan megrendelést adtak le, 
--amely mobil darukkal rendelkezõ kikötõbe irányult (azaz az érkezési kikötõ leírásában szerepel a 'mobil daruk' sztring)!
--Rendezze az eredményt darabszám szerint csökkenõ sorrendbe
SELECT to_char(megrendeles_datuma, 'yyyy') AS EV, to_char(megrendeles_datuma, 'mm') AS HONAP, COUNT(sm.megrendeles_id) AS DB
FROM HAJO.s_megrendeles sm INNER JOIN HAJO.s_kikoto sk ON sm.erkezesi_kikoto=sk.kikoto_id
WHERE sk.leiras LIKE '%mobil daruk%'
GROUP BY to_char(megrendeles_datuma, 'yyyy'), to_char(megrendeles_datuma, 'mm')
ORDER BY DB DESC;

--8. Listázza ki  növekvõ sorrenben az 'Astrerix' nevû hajó által az 'It_Cat' azonosítójú
--kikötõbe szállított megrendelések azonosítóit, mindegyiket csak egyszer
SELECT DISTINCT ss.megrendeles
FROM HAJO.s_szallit ss INNER JOIN HAJO.s_ut su ON ss.ut = su.ut_id INNER JOIN HAJO.s_hajo sh ON su.hajo=sh.hajo_id
WHERE sh.nev LIKE 'Asterix' and su.erkezesi_kikoto LIKE 'It_Cat'
ORDER BY ss.megrendeles ASC;

--9. Írja ki az utoljára leadott megrendelés(ek)nek az azonosítóját, dátumát és idejét, az 
--indulási és érkezési kikötõk azonosítóját, valamint az ügyfél teljes nevét
SELECT sm.megrendeles_id, to_char(sm.megrendeles_datuma, 'yyyy.mm.dd') AS DATUM, to_char(sm.megrendeles_datuma, 'hh24:mi:ss') AS IDO, sm.indulasi_kikoto, sm.erkezesi_kikoto, su.vezeteknev ||' '||su.keresztnev AS nev
FROM HAJO.s_megrendeles sm INNER JOIN HAJO.s_ugyfel su ON sm.ugyfel=su.ugyfel_id
WHERE sm.megrendeles_datuma in (
SELECT MIN(s.megrendeles_datuma)
FROM HAJO.s_megrendeles s);

select m.megrendeles_id, to_char(m.megrendeles_datuma, 'yyyy.mm.dd hh:mi') as datum, 
m.indulasi_kikoto, m.erkezesi_kikoto, u.vezeteknev || ' ' || u.keresztnev as Nev
from hajo.s_megrendeles m
    inner join hajo.s_ugyfel u
        on m.ugyfel = u.ugyfel_id
where m.megrendeles_datuma in(select min(megrendeles_datuma)
from hajo.s_megrendeles );

--10. Írja ki a legidõsebb olaszországi ügyfél/ügyfelek teljes nevét és születési dátumát
SELECT s.vezeteknev ||' '||s.keresztnev AS nev, to_char(s.szul_dat, 'yyyy.mm.dd') AS SZULETESI_DATUM
FROM HAJO.s_ugyfel s
WHERE s.szul_dat in (
SELECT MIN(su.szul_dat)
FROM  HAJO.s_ugyfel su INNER JOIN HAJO.s_helyseg sh ON su.helyseg = sh.helyseg_id
WHERE sh.orszag LIKE 'Olaszország');

