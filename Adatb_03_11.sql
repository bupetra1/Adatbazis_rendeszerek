--101.List�zzuk ki a k�nyvek azonos�t�it, a k�nyvek c�meit �s a k�nyvekhez kapcsol�d� p�ld�nyok lelt�ri sz�mait. (Csak azokat a k�nyveket �s p�ld�nyokat
--list�zzuk, amelyeknek van a m�sik t�bl�ban megfelel�je.)
SELECT kk.konyv_azon, kk.cim, kkk.leltari_szam
FROM konyvtar.konyv kk INNER JOIN konyvtar.konyvtari_konyv kkk
ON kk.konyv_azon=kkk.konyv_azon;

--102. Mi a lelt�ri sz�ma az �csi Mil�n nev� tag aktu�lisan kik�lcs�nz�tt k�nyveinek?
SELECT leltari_szam
FROM konyvtar.tag kt INNER JOIN konyvtar.kolcsonzes kk
ON kt.olvasojegyszam=kk.tag_azon
WHERE kt.vezeteknev='�csi' and kt.keresztnev='Mil�n' and visszahozasi_datum is null;
--103. Milyen k�nyveket (azonons�t� �s c�m) k�lcs�nz�tt �csi Mil�n?
SELECT kv.konyv_azon, kv.cim, to_char(ko.kolcsonzesi_datum,'yyyy.mm.dd') AS kolcsonzesi_ido
FROM konyvtar.tag tg INNER JOIN konyvtar.kolcsonzes ko
 ON tg.olvasojegyszam=ko.tag_azon
 INNER JOIN konyvtar.konyvtari_konyv kk
 ON ko.leltari_szam=kk.leltari_szam
 INNER JOIN konyvtar.konyv kv
 ON kk.konyv_azon=kv.konyv_azon
WHERE vezeteknev='�csi'
AND keresztnev='Mil�n';

--105. Ki �rta a Hasznos holmik c�m� k�nyvet?
SELECT vezeteknev, keresztnev
FROM konyvtar.konyv kv INNER JOIN konyvtar.konyvszerzo ksz
 ON kv.konyv_azon=ksz.konyv_azon INNER JOIN konyvtar.szerzo sz
 ON ksz.szerzo_azon=sz.szerzo_azon
WHERE cim='Hasznos holmik';

--126. Az egyes k�nyveknek h�ny szerz�je van?
SELECT ko.konyv_azon, cim, count(*)
FROM konyvtar.konyv ko INNER JOIN konyvtar.konyvszerzo ksz
 ON ko.konyv_azon=ksz.konyv_azon
GROUP BY ko.konyv_azon, cim, kiado, tema;

--130. Kik azok a tagok , akik egy p�ld�nyt legal�bb k�tszer k�lcs�n�ztek ki?
SELECT tag_azon, kt.vezeteknev, kt.keresztnev
FROM konyvtar.kolcsonzes kk INNER JOIN konyvtar.tag kt
ON kk.tag_azon=kt.olvasojegyszam
GROUP BY tag_azon, leltari_szam,kt.vezeteknev, kt.keresztnev
HAVING count(kolcsonzesi_datum)>1;

--134. Melyik szerz� �rt 3-n�l kevesebb k�nyvet?
SELECT sz.szerzo_azon, vezeteknev, keresztnev, COUNT(konyv_azon)
FROM konyvtar.szerzo sz LEFT OUTER JOIN
 konyvtar.konyvszerzo ksz
 ON sz.szerzo_azon=ksz.szerzo_azon
GROUP BY sz.szerzo_azon, vezeteknev, keresztnev
HAVING COUNT(konyv_azon)<3;

--138. List�zzuk t�m�nk�nt a horror, sci-fi, krimi t�m�j� k�nyvek�rt kapott �sszhonor�riumot!
SELECT tema, SUM(nvl(honorarium,0)) AS ossz_honorarium
FROM konyvtar.konyv ko LEFT OUTER JOIN konyvtar.konyvszerzo ksz
ON ko.konyv_azon=ksz.konyv_azon
WHERE tema IN ('horror', 'sci-fi', 'krimi')
GROUP BY tema;

--142. List�zzuk ki az �sszes krimi t�m�j� k�nyvet, �s ha tartozik hozz�juk p�ld�ny, akkor tegy�k mell� a lelt�ri sz�m�t.
SELECT kv.konyv_azon, cim, kk.leltari_szam
FROM konyvtar.konyv kv LEFT OUTER JOIN konyvtar.konyvtari_konyv kk
ON kv.konyv_azon=kk.konyv_azon
WHERE kv.tema='krimi';

/*
T�bl�k �sszekapcsol�s�ra a JOIN kulcssz�t haszn�ljuk. Ennek az �rdekess�ge, hogy
lehet bels� �s k�ls� m�veletekkel is sz�rakozni
Bels� JOIN: INNER JOIN - megkeresi a k�t t�bl�n�l, azt a k�t oszlopot, ami �rdekel minket
�s ID szerint �sszekapcsolja. Lek�rdez�skor csak azt adja vissza
SELECT *
FROM music INNER JOIN band ON music.band.id = band.id
A sima JOIN-t INNER JOINNAK �rz�keli alapb�l, a program

NATURAL JOIN: 
SELECT *
FROM MUSIC NATURAL JOIN BAND

K�ls� kapcsol�s
SELECT *
FROM music LEFT OUTER JOIN band ON music.band.id=band.id
A bal oldali t�bl�b�l, mindent visszaad, �s amihez tal�l valakit, ahhoz mell� teszi
amit tal�l, ha nem tal�l semmit, akkor null �rt�ket ad vissza
SELECT *
FROM music RIGHT OUTER JOIN band ON music.band.id=band.id
A jobboldali t�bl�b�l sorol fel mindent
SELECT *
FROM music FULL OUTER JOIN band ON music.band.id=band.id
Visszaad mindenb�l mindent, �s amihez nem tal�l p�rt azt null�zza
*/
