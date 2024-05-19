--55. List�zzuk ki a k�nyvek minimum �r�t, maximum �r�t, �ssz�r�t, �tlag�r�t �s 
--darabsz�m�t. Vizsg�ljuk meg, hogy az �tlag�rat hogyan sz�molja a rendszer.
SELECT min(ar), max(ar), sum(ar), avg(ar), count(konyv_azon), sum(ar)/ count(konyv_azon)
FROM konyvtar.konyv;

--56. Sz�moljuk meg, hogy h�ny k�nyv azonos�t�, h�ny �r, �s h�ny sor van a k�nyv 
--t�bl�ba. Figyelj�k meg �s magyar�zzuk meg a k�l�nbs�get.
SELECT count(konyv_azon),count(ar),count(*)
FROM konyvtar.konyv;

--57. H�ny t�ma van?
SELECT count(tema)
FROM konyvtar.konyv;

--58. H�ny darab 70 �vn�l id�sebb szerz� van?
SELECT count(szerzo_azon)
FROM konyvtar.szerzo
WHERE months_between(sysdate, szuletesi_datum)/12>70;

--59. Mi a legid�sebb szerz� sz�let�si d�tuma �s �letkora?
SELECT min(to_char(szuletesi_datum,'yyyy.mm.dd')), months_between(sysdate, min(szuletesi_datum))/12
FROM konyvtar.szerzo;

--60. ABC sorrendben melyik az els� �s az utols� t�ma?
SELECT min(tema),max(tema)
FROM konyvtar.konyv
ORDER BY tema ASC;

--61. List�zzuk ki a t�m�kat! Mindegyik csak egyszer szerepeljen.
SELECT DISTINCT tema
FROM konyvtar.konyv;

--62. H�ny k�l�nb�z� t�ma van?
SELECT count(DISTINCT tema)
FROM konyvtar.konyv;

--63. H�ny darab olyan k�nyv van, amelyiknek a c�me pontosan kett� 'a' bet�t 
--(mindegy, hogy kicsi vagy nagy) tartalmaz?
SELECT cim
FROM konyvtar.konyv
WHERE lower(cim) LIKE '%a%a%' and lower(cim) NOT LIKE '%a%a%a%';

--64. Mi a legid�sebb szerz� sz�let�si d�tuma?
SELECT min(to_char(szuletesi_datum, 'yyyy.mm.dd'))
FROM konyvtar.szerzo;

--65. Mi a t�m�ja azoknak a k�nyveknek, amelyeknek az oldalank�ti �ra 10 �s 150 
--k�z�tt van. Minden t�ma csak egyszer szerepeljen, �s legyen a lista rendezett.
SELECT distinct tema
FROM konyvtar.konyv
WHERE ar/oldalszam between 10 and 150
ORDER BY tema ASC;

--66. Mi a horror, sci-fi vagy krimi t�m�j� k�nyvek �tlag�ra?
SELECT avg(ar)
FROM konyvtar.konyv
WHERE tema in('horror','sci-fi','krimi');

--67. Mi a horror, sci-fi, krimi t�m�j� k�nyvek k�z�l a legdr�g�bbbnak az �ra?
SELECT max(ar)
FROM konyvtar.konyv
WHERE tema in ('horror', 'sci-fi','krimi');

--71. H�ny k�l�nb�z� v�rosn�v szerepel a tagok c�meiben?
SELECT count(distinct substr(cim,6,instr(cim,',')-6)) cica
FROM konyvtar.tag;

--72. H�ny olyan tag van, aki 40 �vn�l fiatalabb vagy a nev�ben pontosan kett� darab 'e' bet� szerepel?
SELECT count(*)
FROM konyvtar.tag
WHERE months_between(sysdate, szuletesi_datum)/12<40
 or (lower(vezeteknev||' '||keresztnev) like '%e%e%'
 and lower(vezeteknev||' '||keresztnev) not like '%e%e%e%');

--78. Az egyes t�m�khoz h�ny k�nyv tartozik?
SELECT tema, count(konyv_azon)
FROM konyvtar.konyv
GROUP BY tema;

--79. Melyek azok a t�m�k, amelyekhez 7-n�l t�bb k�nyv tartozik?
SELECT tema, count(konyv_azon)
FROM konyvtar.konyv
GROUP BY tema
HAVING count(*)>7;

--80. V�rosonk�nt h�ny olyan tag van, aki 1980.03.01 el�tt sz�letett?
SELECT substr(cim, 6,instr(cim,',')-6) varos, count(*) tagok_szama
FROM konyvtar.tag
WHERE szuletesi_datum<(to_date('1980.03.01','yyyy.mm.dd'))
GROUP BY substr(cim, 6,instr(cim,',')-6)
ORDER BY varos;

--81. Melyik szerzo (csak szerzo_azon) �sszhonor�riuma nagyobb, mint 2000000?
SELECT szerzo_azon--, sum(honorarium)
FROM konyvtar.konyvszerzo
GROUP BY szerzo_azon
HAVING sum(honorarium)>2000000;

--84. Momogrammonk�nt h�ny tag van?
SELECT substr(vezeteknev,1,1)||substr(keresztnev,1,1), count(*)
FROM konyvtar.tag
GROUP BY substr(vezeteknev,1,1)||substr(keresztnev,1,1);

--85. Melyik az a sz�let�si �v �s h�nap, amelyikben 10-n�l kevesebb tag sz�letett?
SELECT to_char(szuletesi_datum,'yyyy.mm'), count(*)
FROM konyvtar.tag
GROUP BY to_char(szuletesi_datum,'yyyy.mm')
HAVING count(*)<10;

--86. Besorol�sonk�nt mennyi az �tlagos tagd�j?
SELECT besorolas, avg(tagdij)
FROM konyvtar.tag
GROUP BY besorolas;

--88. Kiad�nk�nt mi a legutols� kiad�s d�tuma?
SELECT kiado, to_char(max(kiadas_datuma),'yyyy.mm.dd')
FROM konyvtar.konyv
GROUP BY kiado;

--97. A 400 oldaln�l kevesebb oldalsz�m� k�nyvek k�z�l t�m�nk�nt mennyi a legolcs�bb k�nyvek �ra.
SELECT tema, min(ar)
FROM konyvtar.konyv
WHERE oldalszam<400
GROUP BY tema;

--99. Melyik az a h�nap (�v n�lk�l), amikor 1-n�l t�bb szerz� sz�letett?
SELECT to_char(szuletesi_datum,'mm'), count(*)
FROM konyvtar.szerzo
GROUP BY to_char(szuletesi_datum,'mm')
HAVING count(*)>1;

/*
******************Matematikai f�ggv�nyek****************************
min(): minimum
max(): maximum
sum(): �sszead�s
avg(): �tlag
count(): megsz�molja a k�l�nb�z� darabokat
count(*): ha sorokat akarunk sz�molni

months_between: h�napok k�t �rt�k k�z�tt
sysdate: mai nap

substr(mibol, hanyadik_karaktertol,meddig_v�gja(instr(miben_keresse,',')-hanyadikkarakter))
*/
