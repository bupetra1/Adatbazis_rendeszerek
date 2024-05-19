--146. Ki a legidõsebb szerzõ?
SELECT *
FROM konyvtar.szerzo
WHERE szuletesi_datum=(
SELECT min(szuletesi_datum)
FROM konyvtar.szerzo);
--145. Melyek azok a szerzõk, akik nem szereztek könyvet?
SELECT *
FROM konyvtar.szerzo
WHERE szerzo_azon not in (
SELECT szerzo_azon
FROM konyvtar.konyvszerzo);

SELECT sz.szerzo_azon, sz.vezeteknev, sz.keresztnev
FROM konyvtar.szerzo sz LEFT OUTER JOIN
 konyvtar.konyvszerzo ksz
 ON sz.szerzo_azon=ksz.szerzo_azon
WHERE ksz.konyv_azon is null;

SELECT sz.szerzo_azon, sz.vezeteknev, sz.keresztnev
FROM konyvtar.konyvszerzo ksz RIGHT OUTER JOIN
 konyvtar.szerzo sz
 ON sz.szerzo_azon=ksz.szerzo_azon
WHERE ksz.konyv_azon is null;

--147. Kérdezzük le a Napóleon címû könyvek leltári számát!
SELECT leltari_szam
FROM konyvtar.konyvtari_konyv
WHERE konyv_azon in (
SELECT konyv_azon
FROM konyvtar.konyv
WHERE cim='Napóleon');

--148. A diák besorolású tagok között ki a legidõsebb?
SELECT *
FROM konyvtar.tag
WHERE szuletesi_datum=(
SELECT min(szuletesi_datum)
FROM konyvtar.tag
WHERE besorolas='diák');

--149. A nõi tagok között mi a legfiatalabb tagnak a neve?
SELECT *
FROM konyvtar.tag
WHERE szuletesi_datum =(
SELECT max(szuletesi_datum)
FROM konyvtar.tag
WHERE nem='n');

--150. Témánként mi a legdrágább árú könyv címe?
SELECT tema,cim
FROM konyvtar.konyv
WHERE (tema,ar) in (
SELECT tema,max(ar)
FROM konyvtar.konyv
GROUP BY tema);

--151. Mi a legdrágább értékû könyv címe?
SELECT cim
FROM konyvtar.konyv
WHERE konyv_azon in (
SELECT konyv_azon
FROM konyvtar.konyvtari_konyv
WHERE ertek=(
SELECT max(ertek)
FROM konyvtar.konyvtari_konyv));

--156. Keressük azokat a tagokat, akiknek van kölcsönzésük.
SELECT keresztnev, vezeteknev
FROM konyvtar.tag
WHERE exists ( --olvasojegyszam in
SELECT *
FROM konyvtar.kolcsonzes
WHERE konyvtar.tag.olvasojegyszam = konyvtar.kolcsonzes.tag_azon);

--SELECT ROWNUMMAL
--163. Listázzuk ki az elsõ 10 legidõsebb tag nevét!
SELECT birthday.*, rownum
FROM 
(SELECT keresztnev, vezeteknev
FROM konyvtar.tag
ORDER BY szuletesi_datum) birthday
WHERE rownum<11;

SELECT birthday.*
FROM 
(SELECT vezeteknev, keresztnev
FROM konyvtar.tag
ORDER BY szuletesi_datum) birthday
FETCH FIRST 10 ROW ONLY;

--164. Listázzuk ki az elsõ 10 legdrágább könyvet
SELECT draga.*, ROWNUM
FROM
(SELECT *
FROM konyvtar.konyv
ORDER BY ar DESC NULLS LAST) draga
WHERE ROWNUM<11;

--165. Kérdezzük le azoknak a szerzõknek a nevét, akik benne vannak abban a listában, akik a 10 legnagyobb honoráriumot kapták.
SELECT keresztnev, vezeteknev
FROM konyvtar.szerzo
WHERE szerzo_azon IN (
SELECT szerzo_azon
FROM (
SELECT *
FROM konyvtar.konyvszerzo
ORDER BY honorarium DESC NULLS LAST)
WHERE rownum<11);

--A beágyazott Select tuti benne lesz a zh-ban.
/*
exists: megnézi hogy van e egyezés a beágyazott lekérdezésben, és visszatér vele

*/