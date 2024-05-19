--101.Listázzuk ki a könyvek azonosítóit, a könyvek címeit és a könyvekhez kapcsolódó példányok leltári számait. (Csak azokat a könyveket és példányokat
--listázzuk, amelyeknek van a másik táblában megfelelõje.)
SELECT kk.konyv_azon, kk.cim, kkk.leltari_szam
FROM konyvtar.konyv kk INNER JOIN konyvtar.konyvtari_konyv kkk
ON kk.konyv_azon=kkk.konyv_azon;

--102. Mi a leltári száma az Ácsi Milán nevû tag aktuálisan kikölcsönzött könyveinek?
SELECT leltari_szam
FROM konyvtar.tag kt INNER JOIN konyvtar.kolcsonzes kk
ON kt.olvasojegyszam=kk.tag_azon
WHERE kt.vezeteknev='Ácsi' and kt.keresztnev='Milán' and visszahozasi_datum is null;
--103. Milyen könyveket (azononsító és cím) kölcsönzött Ácsi Milán?
SELECT kv.konyv_azon, kv.cim, to_char(ko.kolcsonzesi_datum,'yyyy.mm.dd') AS kolcsonzesi_ido
FROM konyvtar.tag tg INNER JOIN konyvtar.kolcsonzes ko
 ON tg.olvasojegyszam=ko.tag_azon
 INNER JOIN konyvtar.konyvtari_konyv kk
 ON ko.leltari_szam=kk.leltari_szam
 INNER JOIN konyvtar.konyv kv
 ON kk.konyv_azon=kv.konyv_azon
WHERE vezeteknev='Ácsi'
AND keresztnev='Milán';

--105. Ki írta a Hasznos holmik címû könyvet?
SELECT vezeteknev, keresztnev
FROM konyvtar.konyv kv INNER JOIN konyvtar.konyvszerzo ksz
 ON kv.konyv_azon=ksz.konyv_azon INNER JOIN konyvtar.szerzo sz
 ON ksz.szerzo_azon=sz.szerzo_azon
WHERE cim='Hasznos holmik';

--126. Az egyes könyveknek hány szerzõje van?
SELECT ko.konyv_azon, cim, count(*)
FROM konyvtar.konyv ko INNER JOIN konyvtar.konyvszerzo ksz
 ON ko.konyv_azon=ksz.konyv_azon
GROUP BY ko.konyv_azon, cim, kiado, tema;

--130. Kik azok a tagok , akik egy példányt legalább kétszer kölcsönöztek ki?
SELECT tag_azon, kt.vezeteknev, kt.keresztnev
FROM konyvtar.kolcsonzes kk INNER JOIN konyvtar.tag kt
ON kk.tag_azon=kt.olvasojegyszam
GROUP BY tag_azon, leltari_szam,kt.vezeteknev, kt.keresztnev
HAVING count(kolcsonzesi_datum)>1;

--134. Melyik szerzõ írt 3-nál kevesebb könyvet?
SELECT sz.szerzo_azon, vezeteknev, keresztnev, COUNT(konyv_azon)
FROM konyvtar.szerzo sz LEFT OUTER JOIN
 konyvtar.konyvszerzo ksz
 ON sz.szerzo_azon=ksz.szerzo_azon
GROUP BY sz.szerzo_azon, vezeteknev, keresztnev
HAVING COUNT(konyv_azon)<3;

--138. Listázzuk témánként a horror, sci-fi, krimi témájú könyvekért kapott összhonoráriumot!
SELECT tema, SUM(nvl(honorarium,0)) AS ossz_honorarium
FROM konyvtar.konyv ko LEFT OUTER JOIN konyvtar.konyvszerzo ksz
ON ko.konyv_azon=ksz.konyv_azon
WHERE tema IN ('horror', 'sci-fi', 'krimi')
GROUP BY tema;

--142. Listázzuk ki az összes krimi témájú könyvet, és ha tartozik hozzájuk példány, akkor tegyük mellé a leltári számát.
SELECT kv.konyv_azon, cim, kk.leltari_szam
FROM konyvtar.konyv kv LEFT OUTER JOIN konyvtar.konyvtari_konyv kk
ON kv.konyv_azon=kk.konyv_azon
WHERE kv.tema='krimi';

/*
Táblák összekapcsolására a JOIN kulcsszót használjuk. Ennek az érdekessége, hogy
lehet belsõ és külsõ mûveletekkel is szórakozni
Belsõ JOIN: INNER JOIN - megkeresi a két táblánál, azt a két oszlopot, ami érdekel minket
És ID szerint összekapcsolja. Lekérdezéskor csak azt adja vissza
SELECT *
FROM music INNER JOIN band ON music.band.id = band.id
A sima JOIN-t INNER JOINNAK érzékeli alapból, a program

NATURAL JOIN: 
SELECT *
FROM MUSIC NATURAL JOIN BAND

Külsõ kapcsolás
SELECT *
FROM music LEFT OUTER JOIN band ON music.band.id=band.id
A bal oldali táblából, mindent visszaad, és amihez talál valakit, ahhoz mellé teszi
amit talál, ha nem talál semmit, akkor null értéket ad vissza
SELECT *
FROM music RIGHT OUTER JOIN band ON music.band.id=band.id
A jobboldali táblából sorol fel mindent
SELECT *
FROM music FULL OUTER JOIN band ON music.band.id=band.id
Visszaad mindenbõl mindent, és amihez nem talál párt azt nullázza
*/
