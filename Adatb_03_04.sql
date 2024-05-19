--55. Listázzuk ki a könyvek minimum árát, maximum árát, összárát, átlagárát és 
--darabszámát. Vizsgáljuk meg, hogy az átlagárat hogyan számolja a rendszer.
SELECT min(ar), max(ar), sum(ar), avg(ar), count(konyv_azon), sum(ar)/ count(konyv_azon)
FROM konyvtar.konyv;

--56. Számoljuk meg, hogy hány könyv azonosító, hány ár, és hány sor van a könyv 
--táblába. Figyeljük meg és magyarázzuk meg a különbséget.
SELECT count(konyv_azon),count(ar),count(*)
FROM konyvtar.konyv;

--57. Hány téma van?
SELECT count(tema)
FROM konyvtar.konyv;

--58. Hány darab 70 évnél idõsebb szerzõ van?
SELECT count(szerzo_azon)
FROM konyvtar.szerzo
WHERE months_between(sysdate, szuletesi_datum)/12>70;

--59. Mi a legidõsebb szerzõ születési dátuma és életkora?
SELECT min(to_char(szuletesi_datum,'yyyy.mm.dd')), months_between(sysdate, min(szuletesi_datum))/12
FROM konyvtar.szerzo;

--60. ABC sorrendben melyik az elsõ és az utolsó téma?
SELECT min(tema),max(tema)
FROM konyvtar.konyv
ORDER BY tema ASC;

--61. Listázzuk ki a témákat! Mindegyik csak egyszer szerepeljen.
SELECT DISTINCT tema
FROM konyvtar.konyv;

--62. Hány különbözõ téma van?
SELECT count(DISTINCT tema)
FROM konyvtar.konyv;

--63. Hány darab olyan könyv van, amelyiknek a címe pontosan kettõ 'a' betût 
--(mindegy, hogy kicsi vagy nagy) tartalmaz?
SELECT cim
FROM konyvtar.konyv
WHERE lower(cim) LIKE '%a%a%' and lower(cim) NOT LIKE '%a%a%a%';

--64. Mi a legidõsebb szerzõ születési dátuma?
SELECT min(to_char(szuletesi_datum, 'yyyy.mm.dd'))
FROM konyvtar.szerzo;

--65. Mi a témája azoknak a könyveknek, amelyeknek az oldalankéti ára 10 és 150 
--között van. Minden téma csak egyszer szerepeljen, és legyen a lista rendezett.
SELECT distinct tema
FROM konyvtar.konyv
WHERE ar/oldalszam between 10 and 150
ORDER BY tema ASC;

--66. Mi a horror, sci-fi vagy krimi témájú könyvek átlagára?
SELECT avg(ar)
FROM konyvtar.konyv
WHERE tema in('horror','sci-fi','krimi');

--67. Mi a horror, sci-fi, krimi témájú könyvek közül a legdrágábbbnak az ára?
SELECT max(ar)
FROM konyvtar.konyv
WHERE tema in ('horror', 'sci-fi','krimi');

--71. Hány különbözõ városnév szerepel a tagok címeiben?
SELECT count(distinct substr(cim,6,instr(cim,',')-6)) cica
FROM konyvtar.tag;

--72. Hány olyan tag van, aki 40 évnél fiatalabb vagy a nevében pontosan kettõ darab 'e' betû szerepel?
SELECT count(*)
FROM konyvtar.tag
WHERE months_between(sysdate, szuletesi_datum)/12<40
 or (lower(vezeteknev||' '||keresztnev) like '%e%e%'
 and lower(vezeteknev||' '||keresztnev) not like '%e%e%e%');

--78. Az egyes témákhoz hány könyv tartozik?
SELECT tema, count(konyv_azon)
FROM konyvtar.konyv
GROUP BY tema;

--79. Melyek azok a témák, amelyekhez 7-nél több könyv tartozik?
SELECT tema, count(konyv_azon)
FROM konyvtar.konyv
GROUP BY tema
HAVING count(*)>7;

--80. Városonként hány olyan tag van, aki 1980.03.01 elõtt született?
SELECT substr(cim, 6,instr(cim,',')-6) varos, count(*) tagok_szama
FROM konyvtar.tag
WHERE szuletesi_datum<(to_date('1980.03.01','yyyy.mm.dd'))
GROUP BY substr(cim, 6,instr(cim,',')-6)
ORDER BY varos;

--81. Melyik szerzo (csak szerzo_azon) összhonoráriuma nagyobb, mint 2000000?
SELECT szerzo_azon--, sum(honorarium)
FROM konyvtar.konyvszerzo
GROUP BY szerzo_azon
HAVING sum(honorarium)>2000000;

--84. Momogrammonként hány tag van?
SELECT substr(vezeteknev,1,1)||substr(keresztnev,1,1), count(*)
FROM konyvtar.tag
GROUP BY substr(vezeteknev,1,1)||substr(keresztnev,1,1);

--85. Melyik az a születési év és hónap, amelyikben 10-nél kevesebb tag született?
SELECT to_char(szuletesi_datum,'yyyy.mm'), count(*)
FROM konyvtar.tag
GROUP BY to_char(szuletesi_datum,'yyyy.mm')
HAVING count(*)<10;

--86. Besorolásonként mennyi az átlagos tagdíj?
SELECT besorolas, avg(tagdij)
FROM konyvtar.tag
GROUP BY besorolas;

--88. Kiadónként mi a legutolsó kiadás dátuma?
SELECT kiado, to_char(max(kiadas_datuma),'yyyy.mm.dd')
FROM konyvtar.konyv
GROUP BY kiado;

--97. A 400 oldalnál kevesebb oldalszámú könyvek közül témánként mennyi a legolcsóbb könyvek ára.
SELECT tema, min(ar)
FROM konyvtar.konyv
WHERE oldalszam<400
GROUP BY tema;

--99. Melyik az a hónap (év nélkül), amikor 1-nél több szerzõ született?
SELECT to_char(szuletesi_datum,'mm'), count(*)
FROM konyvtar.szerzo
GROUP BY to_char(szuletesi_datum,'mm')
HAVING count(*)>1;

/*
******************Matematikai függvények****************************
min(): minimum
max(): maximum
sum(): összeadás
avg(): átlag
count(): megszámolja a különbözõ darabokat
count(*): ha sorokat akarunk számolni

months_between: hónapok két érték között
sysdate: mai nap

substr(mibol, hanyadik_karaktertol,meddig_vágja(instr(miben_keresse,',')-hanyadikkarakter))
*/
