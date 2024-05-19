--1. List�zza ki a 7 �s 14 tonna k�z� es� rakom�nnyal rendelkez� kont�nerek teljes azonos�t�j�t
--megrendel�sazonos�t� �s kont�nerazonos�t�), valamint a rakom�nys�lyt is 2 
--tizedesjegyre kerek�tve. Rendezze az eredm�nyt a pontos rakom�nys�ly szerint cs�kken� sorrendbe!
SELECT h.megrendeles, h.kontener, ROUND(h.rakomanysuly,2) AS rakomanysuly
FROM HAJO.s_hozzarendel h
WHERE h.rakomanysuly between 7 and 14
ORDER BY h.rakomanysuly DESC;

--2. List�zza ki azoknak az �gyfeleknek a teljes nev�t "<vezet�kn�v>, <keresztn�v>" form�tumban
--(azaz a keresztnevet egy vessz�vel �s egy sz�k�zzel v�lassza el a vezet�kn�vt�l),
--akikr�l nem tudjuk, melyik telep�l�sen laknak, de azt igen, hogy a keresztnev�k
-- 5 karakterb�l �ll! A lista legyen vezet�kn�v alapj�n cs�kken� sorrendbe rendezve
SELECT u.vezeteknev ||', '|| u.keresztnev AS nev
FROM HAJO.s_ugyfel u
WHERE u.helyseg IS NULL AND u.keresztnev LIKE '_____'
ORDER BY u.vezeteknev DESC;

--3. List�zza ki a 2021 febru�rj�ban �s �prilis�ban leadott megrendel�sek d�tum�t �s id�pontj�t
--az indul�si, �s �rkez�si kik�t�k azonos�t�j�t, valamint a fizetett �sszeget, ez ut�bbi szerint
--cs�kken� sorrendben
SELECT to_char(m.megrendeles_datuma,'yyyy.mm.dd') AS MEGRENDELES_DATUMA, to_char(m.megrendeles_datuma, 'hh24:mi:ss') AS MEGRENDELES_IDEJE,m.indulasi_kikoto, m.erkezesi_kikoto, m.fizetett_osszeg
FROM HAJO.s_megrendeles m
WHERE to_char(m.megrendeles_datuma,'yyyy.mm.dd') LIKE '2021.02.__' OR to_char(m.megrendeles_datuma,'yyyy.mm.dd') LIKE '2021.04.__' 
ORDER BY m.fizetett_osszeg DESC;

--4. Mekkora az egyes f�ldr�szek ter�lete (a f�ldr�szen tal�lhat� orsz�gok ter�let�nek az �sszege)
--Rendezze az eredm�nyt ter�letek szerint cs�kken� sorrendbe!
--A nem ismerrt f�ldr�sz ne jelenjen meg a list�ban
SELECT o.foldresz, sum(o.terulet) AS terulet
FROM HAJO.s_orszag o
WHERE o.foldresz NOT LIKE 'nem ismert f�ldr�sz'
GROUP BY o.foldresz;

--5. Mely �gyfelek rendeltek �sszesen legal�bb 10 milli� �rt�kben, �s mekkora ez az �rt�k?
--Az �gyfeleket az azonos�t�jukkal adja meg
SELECT m.ugyfel, sum(m.fizetett_osszeg) AS osszeg
FROM HAJO.s_megrendeles m
GROUP BY m.ugyfel
HAVING sum(m.fizetett_osszeg)>=10000000;

--6. List�zza ki azoknak a haj�t�pusoknak a nev�t, amilyen t�pus� haj�kkal rendelkezik a c�g�nk.
--Egy t�pusn�v csak egyszer szerepeljen az eredm�nyben!
SELECT DISTINCT sht.nev
FROM HAJO.s_hajo sh INNER JOIN HAJO.s_hajo_tipus sht ON sh.hajo_tipus = sht.hajo_tipus_id;

--7. Adja meg, hogy az egyes h�napokban (�v, h�nap) h�ny olyan megrendel�st adtak le, 
--amely mobil darukkal rendelkez� kik�t�be ir�nyult (azaz az �rkez�si kik�t� le�r�s�ban szerepel a 'mobil daruk' sztring)!
--Rendezze az eredm�nyt darabsz�m szerint cs�kken� sorrendbe
SELECT to_char(megrendeles_datuma, 'yyyy') AS EV, to_char(megrendeles_datuma, 'mm') AS HONAP, COUNT(sm.megrendeles_id) AS DB
FROM HAJO.s_megrendeles sm INNER JOIN HAJO.s_kikoto sk ON sm.erkezesi_kikoto=sk.kikoto_id
WHERE sk.leiras LIKE '%mobil daruk%'
GROUP BY to_char(megrendeles_datuma, 'yyyy'), to_char(megrendeles_datuma, 'mm')
ORDER BY DB DESC;

--8. List�zza ki  n�vekv� sorrenben az 'Astrerix' nev� haj� �ltal az 'It_Cat' azonos�t�j�
--kik�t�be sz�ll�tott megrendel�sek azonos�t�it, mindegyiket csak egyszer
SELECT DISTINCT ss.megrendeles
FROM HAJO.s_szallit ss INNER JOIN HAJO.s_ut su ON ss.ut = su.ut_id INNER JOIN HAJO.s_hajo sh ON su.hajo=sh.hajo_id
WHERE sh.nev LIKE 'Asterix' and su.erkezesi_kikoto LIKE 'It_Cat'
ORDER BY ss.megrendeles ASC;

--9. �rja ki az utolj�ra leadott megrendel�s(ek)nek az azonos�t�j�t, d�tum�t �s idej�t, az 
--indul�si �s �rkez�si kik�t�k azonos�t�j�t, valamint az �gyf�l teljes nev�t
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

--10. �rja ki a legid�sebb olaszorsz�gi �gyf�l/�gyfelek teljes nev�t �s sz�let�si d�tum�t
SELECT s.vezeteknev ||' '||s.keresztnev AS nev, to_char(s.szul_dat, 'yyyy.mm.dd') AS SZULETESI_DATUM
FROM HAJO.s_ugyfel s
WHERE s.szul_dat in (
SELECT MIN(su.szul_dat)
FROM  HAJO.s_ugyfel su INNER JOIN HAJO.s_helyseg sh ON su.helyseg = sh.helyseg_id
WHERE sh.orszag LIKE 'Olaszorsz�g');

