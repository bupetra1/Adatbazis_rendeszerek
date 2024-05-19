--1. List�zza ki a 15 tonn�t meghalad� rakom�nnyal rendelkez� kont�nerek teljes azonos�t�j�t
--(megrendel�sazonos�t� �s kont�nerazonos�t�), valamint a rakom�nys�ly�t is 2 tizedesjegyre
--kerek�tve! Rendezze az eredm�nyt a pontos rakom�nys�ly szerint n�vekv� sorrendbe
SELECT sh.megrendeles, sh.kontener, ROUND(sh.rakomanysuly,2) AS SULY
FROM HAJO.s_hozzarendel sh
WHERE sh.rakomanysuly>15
ORDER BY SULY ASC;

--2.List�zza ki a kis m�ret�, mobil darukkal rendelkez� kik�t�k adatait! Ezeknek a kik�t�knek
--a le�r�s�ban megtal�lhat� a 'kik�t�m�ret: kicsi', illetve a 'mobil daruk' sztring (nem felt�tlen�l
--ebben a sorrendben)
SELECT *
FROM HAJO.s_kikoto sk
WHERE sk.leiras LIKE '%kik�t�m�ret: kicsi%' AND sk.leiras LIKE '%mobil daruk%';

--3.List�zza ki azoknak az utasoknak az adatait (a d�tumokat id�ponttal egy�tt!), amelyek
--nem eg�sz percben indultak! Rendezze az eredm�nyt az indul�si id� szerint n�vekv� sorrendbe
SELECT su.ugyfel_id, to_char(sm.megrendeles_datuma, 'yyyy.mm.dd hh24:mi:ss') AS MEGRENDELES_DATUMA, su.vezeteknev ||' '|| su.keresztnev AS NEV, su.telefon, su.email, to_char(su.szul_dat,'yyyy.mm.dd hh24:mi:ss') AS SZUL_DATE, su.helyseg, su.utca_hsz
FROM HAJO.s_megrendeles sm INNER JOIN HAJO.s_ugyfel su ON sm.ugyfel = su.ugyfel_id
WHERE to_char(sm.megrendeles_datuma, 'mi:ss') NOT LIKE '__:00'
ORDER BY MEGRENDELES_DATUMA ASC;

--4. H�ny 500 tonn�n�l nagyobb maxim�lis s�lyterhel�s� haj� tartozik az egyes haj�t�pusokhoz?
--A haj�t�pusokat az azonos�t�jukkal adja meg
SELECT sh.hajo_tipus, count(sh.hajo_id) AS DB
FROM HAJO.s_hajo sh
WHERE sh.max_sulyterheles>500
GROUP BY sh.hajo_tipus;

--5. Mely h�napokban (�v, h�nap) adtak le legal�bb 6 megrendel�st? A lista legyen id�rendben
SELECT to_char(sm.megrendeles_datuma,'yyyy') AS EV , to_char(sm.megrendeles_datuma,'mm') AS HONAP, COUNT(sm.megrendeles_id) AS DB
FROM HAJO.s_megrendeles sm
GROUP BY to_char(sm.megrendeles_datuma,'yyyy') , to_char(sm.megrendeles_datuma,'mm')
HAVING COUNT(sm.megrendeles_id)>=6
ORDER BY to_char(sm.megrendeles_datuma,'yyyy'),  to_char(sm.megrendeles_datuma,'mm') ;

--6. List�zza ki a sz�rii �gyfelek teljes nev�t �s telefonsz�m�t!
SELECT su.vezeteknev ||' '|| su.keresztnev AS NEV, su.telefon
FROM HAJO.s_ugyfel su INNER JOIN HAJO.s_helyseg sh ON su.helyseg=sh.helyseg_id
WHERE sh.orszag LIKE 'Sz�ria';

--7. Mennyi az egyes haj�t�pusokhoz tartoz� haj�k legkisebb nett� s�lya?
--A haj�t�pusokat a nev�kkel adja meg! Csak azokat a haj�t�pusokat list�zza, amelyekhez van haj�nk!
SELECT sht.nev, MIN(sh.netto_suly) AS NETTO_SULY
FROM HAJO.s_hajo sh INNER JOIN HAJO.s_hajo_tipus sht ON sh.hajo_tipus = sht.hajo_tipus_id
GROUP BY sht.nev;


--8. Melyik �zsiai telep�l�seken tal�lhat� kik�t�? Az eredm�nyben az orsz�g- �s helys�gneveket adja meg,
--orsz�gn�v, azon bell�l helys�gn�v szerint rendezve!
SELECT sh.orszag, sh.helysegnev
FROM HAJO.s_kikoto sk INNER JOIN HAJO.s_helyseg sh ON sk.helyseg=sh.helyseg_id INNER JOIN HAJO.s_orszag so ON sh.orszag= so.orszag
WHERE so.foldresz LIKE '�zsia'
ORDER BY sh.orszag, sh.helysegnev;

--9. Melyik haj�(k) indult(ak) �tra utolj�ra? List�zza ki ezeknek a haj�knak a nev�t, azonos�t�j�t
--az indul�si �s �rkez�si kik�t�k azonos�t�j�t, valamint az indul�s d�tum�t �s id�pontj�t.
SELECT sh.nev, sh.hajo_id, su.indulasi_kikoto, su.erkezesi_kikoto, to_char(su.indulasi_ido, 'yyyy.mm.dd') AS DATUM, to_char(su.indulasi_ido, 'hh24:mi:ss') AS IDO
FROM HAJO.s_ut su INNER JOIN HAJO.s_hajo sh ON su.hajo=sh.hajo_id
WHERE su.indulasi_ido in (
SELECT min(indulasi_ido)
FROM HAJO.s_ut);

--10. Az 'It_Cat' azonos�t�j� kik�t�b�l indul� legkor�bbi �t/utak melyik kik�t�(k)be sz�ll�tottak?
--Adja meg az �rkez�si kik�t�(k) azonos�t�j�t, valamint a helys�geknek �s orsz�goknak a nev�t
SELECT s.erkezesi_kikoto, sh.orszag, sh.helysegnev
FROM HAJO.s_ut s INNER JOIN HAJO.s_kikoto sk ON s.indulasi_kikoto=sk.kikoto_id INNER JOIN HAJO.s_helyseg sh ON sk.helyseg = sh.helyseg_id
WHERE s.indulasi_ido in(
SELECT min(su.indulasi_ido)
FROM HAJO.s_ut su
WHERE su.indulasi_kikoto LIKE 'It_Cat');