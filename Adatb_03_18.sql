--146. Ki a legid�sebb szerz�?
SELECT *
FROM konyvtar.szerzo
WHERE szuletesi_datum=(
SELECT min(szuletesi_datum)
FROM konyvtar.szerzo);
--145. Melyek azok a szerz�k, akik nem szereztek k�nyvet?
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

--147. K�rdezz�k le a Nap�leon c�m� k�nyvek lelt�ri sz�m�t!
SELECT leltari_szam
FROM konyvtar.konyvtari_konyv
WHERE konyv_azon in (
SELECT konyv_azon
FROM konyvtar.konyv
WHERE cim='Nap�leon');

--148. A di�k besorol�s� tagok k�z�tt ki a legid�sebb?
SELECT *
FROM konyvtar.tag
WHERE szuletesi_datum=(
SELECT min(szuletesi_datum)
FROM konyvtar.tag
WHERE besorolas='di�k');

--149. A n�i tagok k�z�tt mi a legfiatalabb tagnak a neve?
SELECT *
FROM konyvtar.tag
WHERE szuletesi_datum =(
SELECT max(szuletesi_datum)
FROM konyvtar.tag
WHERE nem='n');

--150. T�m�nk�nt mi a legdr�g�bb �r� k�nyv c�me?
SELECT tema,cim
FROM konyvtar.konyv
WHERE (tema,ar) in (
SELECT tema,max(ar)
FROM konyvtar.konyv
GROUP BY tema);

--151. Mi a legdr�g�bb �rt�k� k�nyv c�me?
SELECT cim
FROM konyvtar.konyv
WHERE konyv_azon in (
SELECT konyv_azon
FROM konyvtar.konyvtari_konyv
WHERE ertek=(
SELECT max(ertek)
FROM konyvtar.konyvtari_konyv));

--156. Keress�k azokat a tagokat, akiknek van k�lcs�nz�s�k.
SELECT keresztnev, vezeteknev
FROM konyvtar.tag
WHERE exists ( --olvasojegyszam in
SELECT *
FROM konyvtar.kolcsonzes
WHERE konyvtar.tag.olvasojegyszam = konyvtar.kolcsonzes.tag_azon);

--SELECT ROWNUMMAL
--163. List�zzuk ki az els� 10 legid�sebb tag nev�t!
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

--164. List�zzuk ki az els� 10 legdr�g�bb k�nyvet
SELECT draga.*, ROWNUM
FROM
(SELECT *
FROM konyvtar.konyv
ORDER BY ar DESC NULLS LAST) draga
WHERE ROWNUM<11;

--165. K�rdezz�k le azoknak a szerz�knek a nev�t, akik benne vannak abban a list�ban, akik a 10 legnagyobb honor�riumot kapt�k.
SELECT keresztnev, vezeteknev
FROM konyvtar.szerzo
WHERE szerzo_azon IN (
SELECT szerzo_azon
FROM (
SELECT *
FROM konyvtar.konyvszerzo
ORDER BY honorarium DESC NULLS LAST)
WHERE rownum<11);

--A be�gyazott Select tuti benne lesz a zh-ban.
/*
exists: megn�zi hogy van e egyez�s a be�gyazott lek�rdez�sben, �s visszat�r vele

*/