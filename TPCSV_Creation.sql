/*Yannis Hutt 11408376 Julien Granjon 11509496 */

--------------------------------------------------------------------------------
--              LIFBDW2 - 2017-2018 Printemps - TPCSV
--------------------------------------------------------------------------------


---------------------------------------------------------------
-- Exercice 6
---------------------------------------------------------------

-------------
-- Ex6 Q1
-------------

/* on a 
  REGION            ?-> CODE_REGION   Respecter
  CODE_REGION       ?-> REGION        Respecter
  CODE_DEPARTEMENT  ?-> DEPARTEMENT   Respecter
  DEPARTEMENT       ?-> CODE_DEPARTEMENT  Respecter
  CODE_DEPARTEMENT  ?-> CODE_REGION   Respecter
  ACADEMIE          ?-> CODE_ACADEMIE Respecter
  CODE_ACADEMIE     ?-> ACADEMIE Respecter
  CODE_ACADEMIE     ?-> CODE_REGION Respecter
  CODE_REGION       ?-> CODE_REGION Respecter
  CODE_DEPARTEMENT  ?-> CODE_ACADEMIE Respecter
  CODE_ACADEMIE     ?-> CODE_DEPARTEMENT Non Respecter
  CODE_REGION       ?-> CODE_ACADEMIE Non Respecter
  CODE_REGION       ?-> CODE_DEPARTEMENT Non Respecter 
*/

-- CONTRE EXEMPLES

SELECT COUNT(*) AS DF1_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_REGION = t2.CODE_REGION 
AND t1.REGION <> t2.REGION; /* renvoie 0*/

SELECT COUNT(*) AS DF1_2
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.REGION = t2.REGION 
AND t1.CODE_REGION <> t2.CODE_REGION; /* renvoie 0*/

/****************************************************/

SELECT COUNT(*) AS DF2_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_DEPARTEMENT = t2.CODE_DEPARTEMENT
AND t1.DEPARTEMENT <> t2.DEPARTEMENT; /* renvoie 0*/

SELECT COUNT(*) AS DF2_2
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.DEPARTEMENT = t2.DEPARTEMENT 
AND t1.CODE_DEPARTEMENT <> t2.CODE_DEPARTEMENT; /* renvoie 0*/

/****************************************************/

SELECT COUNT(*) AS DF3_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_DEPARTEMENT = t2.CODE_DEPARTEMENT 
AND t1.CODE_REGION <> t2.CODE_REGION; /* renvoie 0*/

SELECT COUNT(*) AS DF3_2
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_REGION = t2.CODE_REGION 
AND t1.CODE_DEPARTEMENT <> t2.CODE_DEPARTEMENT; /* renvoie 214102*/

/*Contre exemple */
SELECT distinct t1.CODE_REGION,t1.CODE_DEPARTEMENT
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_REGION = t2.CODE_REGION 
AND t1.CODE_DEPARTEMENT <> t2.CODE_DEPARTEMENT
WHERE t1.CODE_REGION LIKE 'R11';

/****************************************************/

SELECT COUNT(*) AS DF4_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_ACADEMIE = t2.CODE_ACADEMIE
AND t1.ACADEMIE <> t2.ACADEMIE; /* renvoie 0*/

SELECT COUNT(*) AS DF4_2
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.ACADEMIE = t2.ACADEMIE 
AND t1.CODE_ACADEMIE <> t2.CODE_ACADEMIE; /* renvoie 0*/

/****************************************************/

SELECT COUNT(*) AS DF5_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_ACADEMIE = t2.CODE_ACADEMIE
AND t1.CODE_REGION <> t2.CODE_REGION; /* renvoie 0*/


SELECT COUNT(*) AS DF5_2
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_REGION = t2.CODE_REGION 
AND t1.CODE_ACADEMIE <> t2.CODE_ACADEMIE; /* renvoie 143100*/

/*Contre exemple */
SELECT distinct t1.CODE_REGION,t1.CODE_ACADEMIE
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_REGION = t2.CODE_REGION 
AND t1.CODE_ACADEMIE <> t2.CODE_ACADEMIE
WHERE t1.CODE_REGION LIKE 'R11';

/****************************************************/

SELECT COUNT(*) AS DF6_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_DEPARTEMENT = t2.CODE_DEPARTEMENT
AND t1.CODE_ACADEMIE <> t2.CODE_ACADEMIE; /* renvoie 0*/

SELECT COUNT(*) AS DF6_2
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_ACADEMIE = t2.CODE_ACADEMIE
AND t1.CODE_DEPARTEMENT <> t2.CODE_DEPARTEMENT; /* renvoie 71002*/

/*Contre exemple */
SELECT distinct t1.CODE_ACADEMIE,t1.CODE_DEPARTEMENT
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_ACADEMIE = t2.CODE_ACADEMIE
AND t1.CODE_DEPARTEMENT <> t2.CODE_DEPARTEMENT
WHERE t1.CODE_ACADEMIE LIKE 'A24';


---------------------------------------------------------------
-- Exercice 7
---------------------------------------------------------------

-------------
-- Ex7 Q1
-------------

DROP TABLE TPCSV_REGION;
CREATE TABLE TPCSV_REGION(/* ... */ );

DROP TABLE TPCSV_ACADEMIE;
CREATE TABLE TPCSV_ACADEMIE(/* ... */ );
  
DROP TABLE TPCSV_DPT;
CREATE TABLE TPCSV_DPT(/* ... */ );


-------------
-- Ex7 Q2
-------------

drop table TPCSV_DPT;
drop table TPCSV_ACADEMIE;
drop table TPCSV_REGION;


CREATE TABLE TPCSV_REGION(CODE_REGION VARCHAR2(26 BYTE) CONSTRAINT cleregion PRIMARY KEY, 
                          REGION VARCHAR2(128 BYTE)
                          );

CREATE TABLE TPCSV_ACADEMIE(CODE_ACADEMIE VARCHAR2(26 BYTE) CONSTRAINT cleacademie PRIMARY KEY, 
                            ACADEMIE VARCHAR2(26 BYTE),
                            CODE_REGION VARCHAR2(26 BYTE),
                            CONSTRAINT cleetrangereregion FOREIGN KEY (CODE_REGION) REFERENCES TPCSV_REGION(CODE_REGION)
                            );
                            
CREATE TABLE TPCSV_DPT(CODE_DEPARTEMENT VARCHAR2(26 BYTE) CONSTRAINT cledepartement PRIMARY KEY, 
                       DEPARTEMENT VARCHAR2(26 BYTE), 
                       CODE_REGION VARCHAR2(26 BYTE),
                       CONSTRAINT cleetrangereregion2 FOREIGN KEY (CODE_REGION) REFERENCES TPCSV_REGION(CODE_REGION),
                       CODE_ACADEMIE VARCHAR2(26 BYTE),
                       CONSTRAINT cleetrangereacademie FOREIGN KEY (CODE_ACADEMIE) REFERENCES TPCSV_ACADEMIE(CODE_ACADEMIE)
                       );

COMMIT;


/*Écrire les requêtes SQL qui remplissent ces trois tables à partir de TPCSV_BRUT. */


INSERT INTO TPCSV_REGION(CODE_REGION, REGION) 
SELECT DISTINCT CODE_REGION, REGION 
FROM TPCSV_BRUT
WHERE TPCSV_BRUT.CODE_REGION IS NOT NULL AND REGION IS NOT NULL;

INSERT INTO TPCSV_ACADEMIE(CODE_ACADEMIE, ACADEMIE, CODE_REGION) 
SELECT DISTINCT CODE_ACADEMIE, ACADEMIE, CODE_REGION
FROM TPCSV_BRUT
WHERE CODE_ACADEMIE IS NOT NULL;

INSERT INTO TPCSV_DPT(CODE_DEPARTEMENT, DEPARTEMENT, CODE_REGION,CODE_ACADEMIE) 
SELECT DISTINCT CODE_DEPARTEMENT, DEPARTEMENT, CODE_REGION,CODE_ACADEMIE 
FROM TPCSV_BRUT
WHERE CODE_DEPARTEMENT IS NOT NULL AND CODE_REGION IS NOT NULL AND CODE_ACADEMIE IS NOT NULL;


---------------------------------------------------------------
-- Exercice 8
---------------------------------------------------------------

-------------
-- Ex8 Q1
-------------

drop table TPCSV_DISCIPLINE;
drop table TPCSV_DOMAINE;

CREATE TABLE TPCSV_DOMAINE(CODE_DOMAINE VARCHAR2(26 BYTE) CONSTRAINT cledomaine PRIMARY KEY, 
                           NOM_DOMAINE VARCHAR2(128 BYTE)
                           );
                          
CREATE TABLE TPCSV_DISCIPLINE(CODE_DISCIPLINE VARCHAR2(26 BYTE) CONSTRAINT clediscipline PRIMARY KEY, 
                               NOM_DISCIPLINE VARCHAR2(128 BYTE), 
                               CODE_DOMAINE VARCHAR2(26 BYTE),
                               CONSTRAINT cleetrangeredomaine FOREIGN KEY (CODE_DOMAINE) REFERENCES TPCSV_DOMAINE(CODE_DOMAINE)
                               );
                               


-------------
-- Ex8 Q2
-------------

INSERT INTO TPCSV_DOMAINE(CODE_DOMAINE, NOM_DOMAINE) 
SELECT DISTINCT CODE_DOMAINE, NOM_DOMAINE
FROM TPCSV_BRUT
WHERE CODE_DOMAINE IS NOT NULL;


INSERT INTO TPCSV_DISCIPLINE(CODE_DISCIPLINE, NOM_DISCIPLINE,CODE_DOMAINE) 
SELECT DIStinct CODE_DISCIPLINE, NOM_DISCIPLINE,CODE_DOMAINE 
FROM TPCSV_BRUT
WHERE CODE_DOMAINE IS NOT NULL AND CODE_Discipline IS NOT NULL AND NOM_DISCIPLINE IS NOT NULL
AND nom_discipline NOT IN (Select distinct nom_discipline
from TPCSV_BRUT t1 join Discipline_aggregats t2 on (t1.code_discipline = t2.code_discipline)
where t1.nom_discipline LIKE 'Ensemble%');


COMMIT;

---------------------------------------------------------------
-- Exercice 9
---------------------------------------------------------------

-------------
-- Ex9 Q1
-------------

SELECT COUNT(*) AS IdentifiantUnique
FROM (SELECT DISTINCT CAST(SUBSTR(IDENTIFIANT, 0, 7) AS NUMBER) AS Identifiant, NOM_ETABLISSEMENT
      FROM TPCSV_BRUT
      WHERE IDENTIFIANT <> 'ns' AND IDENTIFIANT <> 'nd' AND LENGTH(IDENTIFIANT) > 6) t1
        JOIN ( SELECT DISTINCT CAST(SUBSTR(IDENTIFIANT, 0, 7) AS NUMBER) AS Identifiant, NOM_ETABLISSEMENT
               FROM TPCSV_BRUT
               WHERE IDENTIFIANT <> 'ns' AND IDENTIFIANT <> 'nd' AND LENGTH(IDENTIFIANT) > 6) t2
        ON t1.NOM_ETABLISSEMENT  = t2.NOM_ETABLISSEMENT
        WHERE t1.Identifiant <> t2.Identifiant;     /* renvoie 0*/
        

SELECT DISTINCT SECTEUR_ETABLISSEMENT
FROM TPCSV_BRUT;

/* renvoi null et public */


-------------
-- Ex9 Q2
-------------
drop table TPCSV_ETA;

CREATE TABLE TPCSV_ETA(ID_ETABLISSEMENT NUMBER CONSTRAINT cleetablissement PRIMARY KEY,
                       IDENTIFIANT VARCHAR2(28 BYTE),
                       LIBELLE_ETABLISSEMENT VARCHAR2(128 BYTE),
                       SIGLE_ETABLISSEMENT VARCHAR2(28 BYTE),
                       TYPE_ETABLISSEMENT VARCHAR2(128 BYTE),
                       SECTEUR_ETABLISSEMENT VARCHAR2(26 BYTE),
                       SITE_INTERNET VARCHAR2(128 BYTE),
                       CODE_DEPARTEMENT VARCHAR2(26 BYTE),
                       STATUT_JURIDIQUE_COURT VARCHAR2(26 BYTE)
                       );

-------------
-- Ex9 Q3
-------------
INSERT INTO TPCSV_ETA(  ID_ETABLISSEMENT,
                        IDENTIFIANT,
                        LIBELLE_ETABLISSEMENT,
                        SIGLE_ETABLISSEMENT,
                        TYPE_ETABLISSEMENT,
                        SECTEUR_ETABLISSEMENT,
                        SITE_INTERNET,
                        CODE_DEPARTEMENT,
                        STATUT_JURIDIQUE_COURT) 
                           
SELECT DISTINCT CAST(SUBSTR(IDENTIFIANT, 0, 7) AS NUMBER) AS ID_ETABLISSEMENT,IDENTIFIANT, 
LIBELLE, SIGLE, TYPE_ETABLISSEMENT, SECTEUR_ETABLISSEMENT, SITE_INTERNET, 
CODE_DEPARTEMENT, STATUT_JURIDIQUE_COURT 
FROM TPCSV_BRUT
WHERE STATUT_JURIDIQUE_COURT IS NOT NULL AND SIGLE IS NOT NULL;

---------------------------------------------------------------
-- Exercice 10
---------------------------------------------------------------

-------------
-- Ex10 Q1
-------------

create or replace function outil (chainecaractere IN varchar2) return number
IS numero NUMBER ;
begin
numero := TO_NUMBER(chainecaractere, '9999.9999');
return numero;
EXCEPTION
when VALUE_ERROR THEN
return NULL;
end outil;
/

/* test de la fonction */

select outil('152.987') from dual;


-------------
-- Ex10 Q2
-------------

Select distinct count(*) as DF_10
from TPCSV_BRUT t1 join TPCSV_BRUT t2 
ON t1.CODE_REGION = t2.CODE_REGION AND t1.annee = t2.annee
where t1.SALAIRE_NET_MEDIAN_REGION <> t2.SALAIRE_NET_MEDIAN_REGION
OR t1.TAUX_CHOMAGE_REGIONAL <> t2.TAUX_CHOMAGE_REGIONAL;
/* renvoi 0 */

-------------
-- Ex10 Q3
-------------
/* Il ne sert a rien de tester les dépendances fonctionnel car on sait deja que l'académie implique la region et que le departement egalement. */


-------------
-- Ex10 Q4
-------------

drop table TPCSV_REGION_STATS;

CREATE TABLE TPCSV_REGION_STATS (
                                CODE_REGION VARCHAR2(128 BYTE),
                                REGION VARCHAR2(128 BYTE),
                                ANNEE NUMBER(10,0),
                                SALAIRE_NET_MEDIAN_REGION VARCHAR2(26 BYTE),
                                TAUX_CHOMAGE_REGIONAL VARCHAR2(26 BYTE),
                                CONSTRAINT cleprimaire PRIMARY KEY (ANNEE,CODE_REGION)
                                );


-------------
-- Ex10 Q5
-------------

INSERT INTO TPCSV_REGION_STATS( CODE_REGION,
                                REGION,
                                ANNEE,
                                SALAIRE_NET_MEDIAN_REGION,
                                TAUX_CHOMAGE_REGIONAL
                                ) 
                                
SELECT DISTINCT t2.CODE_REGION, t2.REGION,t2.ANNEE,t2.SALAIRE_NET_MEDIAN_REGION,t2.TAUX_CHOMAGE_REGIONAL
FROM TPCSV_BRUT t1 join (SELECT distinct CODE_REGION,REGION, ANNEE,SUM(outil(SALAIRE_NET_MEDIAN_REGION)) AS SALAIRE_NET_MEDIAN_REGION, SUM(outil(TAUX_CHOMAGE_REGIONAL)) AS TAUX_CHOMAGE_REGIONAL
                      FROM TPCSV_BRUT 
                      where CODE_REGION IS NOT NULL
                      group by CODE_REGION, ANNEE, REGION) t2
                      ON t1.CODE_REGION = t2.CODE_REGION AND t1.ANNEE=t2.ANNEE

group by t2.CODE_REGION, t2.REGION, t2.ANNEE,t2.SALAIRE_NET_MEDIAN_REGION, t2.TAUX_CHOMAGE_REGIONAL;      

COMMIT; 


---------------------------------------------------------------
-- Exercice 11
---------------------------------------------------------------

-------------
-- Ex11 Q1 et Q2
------------- 

drop table TPCSV_STATS;

CREATE TABLE TPCSV_STATS ( ID_ETABLISSEMENT NUMBER, 
                           NOM_DISCIPLINE VARCHAR2(128 BYTE),
                           TAUX_INSERTION VARCHAR2(26 BYTE),
                           TAUX_CADRES_INTERMEDIAIRES VARCHAR2(26 BYTE),
                           TAUX_STABLES VARCHAR2(26 BYTE),
                           TAUX_TEMPS_PLEIN VARCHAR2(26 BYTE),
                           SALAIRE_NET_MEDIAN VARCHAR2(26 BYTE),
                           SALAIRE_BRUT_ANNUEL VARCHAR2(26 BYTE),
                           TAUX_DIPLOMES_BOURSIERS VARCHAR2(26 BYTE),
                           TAUX_CHOMAGE_REGIONAL VARCHAR2(26 BYTE),
                           SALAIRE_NET_MEDIAN_REGION VARCHAR2(26 BYTE),
                           TAUX_CADRES VARCHAR2(26 BYTE),
                           TAUX_EXTERIEURS VARCHAR2(26 BYTE),
                           TAUX_FEMMES VARCHAR2(26 BYTE),
                           CONSTRAINT cleetrangereetablissement2 FOREIGN KEY (ID_ETABLISSEMENT) REFERENCES TPCSV_ETA(ID_ETABLISSEMENT),
                           CONSTRAINT clediscipline2 PRIMARY KEY (NOM_DISCIPLINE,ID_ETABLISSEMENT)                           
                           );
                           


INSERT INTO TPCSV_STATS (  ID_ETABLISSEMENT,
                           NOM_DISCIPLINE,
                           TAUX_INSERTION,
                           TAUX_CADRES_INTERMEDIAIRES,
                           TAUX_STABLES,
                           TAUX_TEMPS_PLEIN,
                           SALAIRE_NET_MEDIAN,
                           SALAIRE_BRUT_ANNUEL,
                           TAUX_DIPLOMES_BOURSIERS,
                           TAUX_CHOMAGE_REGIONAL,
                           SALAIRE_NET_MEDIAN_REGION,
                           TAUX_CADRES,
                           TAUX_EXTERIEURS,
                           TAUX_FEMMES)  
                           
                           
SELECT DISTINCT t2.ID_ETABLISSEMENT,t1.NOM_DISCIPLINE,t1.TAUX_INSERTION,t1.TAUX_CADRES_INTERMEDIAIRES,t1.TAUX_STABLES,t1.TAUX_TEMPS_PLEIN,
t1.SALAIRE_NET_MEDIAN,t1.SALAIRE_BRUT_ANNUEL,t1.TAUX_DIPLOMES_BOURSIERS,t1.TAUX_CHOMAGE_REGIONAL,t1.SALAIRE_NET_MEDIAN_REGION,t1.TAUX_CADRES,t1.TAUX_EXTERIEURS,t1.TAUX_FEMMES
FROM TPCSV_BRUT t1 left JOIN TPCSV_ETA t2 ON t2.IDENTIFIANT = t1.IDENTIFIANT
WHERE t2.ID_ETABLISSEMENT IS NOT NULL
AND t1.NOM_DISCIPLINE IS NOT NULL
AND t1.TAUX_REPONSE IS NOT NULL
AND t1.TAUX_INSERTION IS NOT NULL 
AND t1.TAUX_INSERTION <> 'nd' 
AND t1.TAUX_INSERTION <> 'ns'
AND t1.TAUX_CADRES_INTERMEDIAIRES IS NOT NULL 
AND t1.TAUX_CADRES_INTERMEDIAIRES <> 'nd' 
AND t1.TAUX_CADRES_INTERMEDIAIRES <> 'ns'
AND t1.TAUX_STABLES IS NOT NULL 
AND t1.TAUX_STABLES <> 'nd' 
AND t1.TAUX_STABLES <> 'ns'
AND t1.TAUX_TEMPS_PLEIN IS NOT NULL 
AND t1.TAUX_TEMPS_PLEIN <> 'nd' 
AND t1.TAUX_TEMPS_PLEIN <> 'ns'
AND t1.SALAIRE_NET_MEDIAN IS NOT NULL 
AND t1.SALAIRE_NET_MEDIAN <> 'nd' 
AND t1.SALAIRE_NET_MEDIAN <> 'ns'
AND t1.SALAIRE_BRUT_ANNUEL IS NOT NULL 
AND t1.SALAIRE_BRUT_ANNUEL <> 'nd' 
AND t1.SALAIRE_BRUT_ANNUEL <> 'ns'
AND t1.TAUX_DIPLOMES_BOURSIERS IS NOT NULL
AND t1.TAUX_CHOMAGE_REGIONAL IS NOT NULL
AND t1.SALAIRE_NET_MEDIAN_REGION IS NOT NULL
AND t1.TAUX_CADRES IS NOT NULL 
AND t1.TAUX_CADRES <> 'nd' 
AND t1.TAUX_CADRES <> 'ns'
AND t1.TAUX_EXTERIEURS IS NOT NULL 
AND t1.TAUX_EXTERIEURS <> 'nd' 
AND t1.TAUX_EXTERIEURS <> 'ns'
AND t1.TAUX_FEMMES IS NOT NULL 
AND t1.TAUX_FEMMES <> 'nd' 
AND t1.TAUX_FEMMES <> 'ns';

COMMIT;

-------------
-- Ex11 Q3
-------------
SELECT DISTINCT COUNT(*) FROM TPCSV_BRUT; /* 2025 */
SELECT DISTINCT COUNT(*) FROM TPCSV_BRUT WHERE IDENTIFIANT <> 'UNIV' AND nom_discipline NOT LIKE 'Ensemble%' AND CODE_discipline <> 'disc18'; /* 1988 */
SELECT DISTINCT COUNT(*) FROM TPCSV_STATS; /* 80 */
       

---------------------------------------------------------------
-- Exercice 12
---------------------------------------------------------------

-------------
-- Ex12 Q1
-------------
 
create or replace VIEW ETABLISSEMENT_STATS AS
SELECT distinct t3.NOM_ETABLISSEMENT AS nomEtablissement_insertion,t3.annee,t3.NOM_DISCIPLINE

SELECT distinct NOM_ETABLISSEMENT,ANNEE,ROUND(MAX(outil(TAUX_INSERTION))),ROUND(MIN(outil(TAUX_INSERTION))),ROUND(AVG(outil(TAUX_INSERTION))),
                                        ROUND(MAX(outil(TAUX_CADRES_INTERMEDIAIRES))),ROUND(MIN(outil(TAUX_CADRES_INTERMEDIAIRES))),ROUND(AVG(outil(TAUX_CADRES_INTERMEDIAIRES))),
                                        ROUND(MAX(outil(TAUX_STABLES))),ROUND(MIN(outil(TAUX_STABLES))),ROUND(AVG(outil(TAUX_STABLES))),
                                        ROUND(MAX(outil(TAUX_TEMPS_PLEIN))),ROUND(MIN(outil(TAUX_TEMPS_PLEIN))),ROUND(AVG(outil(TAUX_TEMPS_PLEIN))),
                                        ROUND(MAX(outil(SALAIRE_NET_MEDIAN))),ROUND(MIN(outil(SALAIRE_NET_MEDIAN))),ROUND(AVG(outil(SALAIRE_NET_MEDIAN))),
                                        ROUND(MAX(outil(SALAIRE_BRUT_ANNUEL))),ROUND(MIN(outil(SALAIRE_BRUT_ANNUEL))),ROUND(AVG(outil(SALAIRE_BRUT_ANNUEL))),
                                        ROUND(MAX(outil(TAUX_DIPLOMES_BOURSIERS))),ROUND(MIN(outil(TAUX_DIPLOMES_BOURSIERS))),ROUND(AVG(outil(TAUX_DIPLOMES_BOURSIERS))),
                                        ROUND(MAX(outil(TAUX_CHOMAGE_REGIONAL))),ROUND(MIN(outil(TAUX_CHOMAGE_REGIONAL))),ROUND(AVG(outil(TAUX_CHOMAGE_REGIONAL))),
                                        ROUND(MAX(outil(SALAIRE_NET_MEDIAN_REGION))),ROUND(MIN(outil(SALAIRE_NET_MEDIAN_REGION))),ROUND(AVG(outil(SALAIRE_NET_MEDIAN_REGION))),
                                        ROUND(MAX(outil(TAUX_CADRES))),ROUND(MIN(outil(TAUX_CADRES))),ROUND(AVG(outil(TAUX_CADRES))),
                                        ROUND(MAX(outil(TAUX_EXTERIEURS))),ROUND(MIN(outil(TAUX_EXTERIEURS))),ROUND(AVG(outil(TAUX_EXTERIEURS))),
                                        ROUND(MAX(outil(TAUX_FEMMES))),ROUND(MIN(outil(TAUX_FEMMES))),ROUND(AVG(outil(TAUX_FEMMES)))
from TPCSV_BRUT
group by NOM_etablissement,ANNEE;  


-------------
-- Ex12 Q2
-------------

create or replace VIEW DISCIPLINE_REPRESENTE AS
  SELECT distinct t3.NOM_ETABLISSEMENT AS nomEtablissement_insertion,t3.annee,t3.NOM_DISCIPLINE
  from ( SELECT distinct t1.NOM_ETABLISSEMENT,t1.annee,t1.NOM_DISCIPLINE,t2.nbmax2
        from ( SELECT distinct  NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE, AVG(outil(taux_insertion)) as taux_insertion2
                                    from TPCSV_BRUT
                                    group by NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE) t1 
                                    join 
                                    ( SELECT annee,NOM_DISCIPLINE,MAX(taux_insertion2) as nbmax2
                                    from (SELECT DISTINCT NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE, AVG(outil(taux_insertion)) as taux_insertion2
                                        from TPCSV_BRUT
                                        group by annee, NOM_DISCIPLINE, NOM_ETABLISSEMENT)
                                        where taux_insertion2 IS NOT NULL
                                         group by annee,NOM_DISCIPLINE
                                        ) t2
                                    ON t1.ANNEE = t2.ANNEE AND t1.NOM_DISCIPLINE = t2.NOM_DISCIPLINE AND t2.nbmax2=t1.taux_insertion2
        where taux_insertion2 IS NOT NULL
        group by t1.NOM_ETABLISSEMENT, t1.annee, t1.NOM_DISCIPLINE, t2.nbmax2
        ) t3 join (  SELECT distinct t1.NOM_ETABLISSEMENT,t1.annee,t1.NOM_DISCIPLINE, MAX(moyenstable) as nbmax
                    from ( SELECT DISTINCT NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE, AVG(outil(taux_stables)) as moyenstable
                                                from TPCSV_BRUT
                                                group by NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE) t1 
                                                join 
                                                ( SELECT annee,NOM_DISCIPLINE,MAX(moyenstable) as nbmax2
                                                from (SELECT DISTINCT NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE, AVG(outil(taux_stables)) as moyenstable
                                                    from TPCSV_BRUT
                                                    group by NOM_ETABLISSEMENT,annee,NOM_DISCIPLINE)
                                                    where moyenstable IS NOT NULL
                                                     group by annee,NOM_DISCIPLINE
                                                    ) t2
                                                ON t1.ANNEE = t2.ANNEE AND t1.NOM_DISCIPLINE = t2.NOM_DISCIPLINE AND t2.nbmax2=t1.moyenstable
                    where moyenstable IS NOT NULL
                    group by t1.NOM_ETABLISSEMENT,t1.annee,t1.NOM_DISCIPLINE
                    )t4
                    ON t3.ANNEE = t4.ANNEE AND t3.NOM_DISCIPLINE = t4.NOM_DISCIPLINE AND t3.nom_etablissement = t4.nom_etablissement;
                    
                    
/* Q3 Donne la liste des établissements ayant amélioré leur taux d’insertion entre 2010 et 2011.  */

SELECT DISTINCT t1.NOM_ETABLISSEMENT
FROM (  SELECT TAUX_INSERTION,NOM_ETABLISSEMENT
        FROM TPCSV_BRUT 
        WHERE ANNEE = '2011'
        ) t1  JOIN (   SELECT TAUX_INSERTION,NOM_ETABLISSEMENT
                        FROM TPCSV_BRUT 
                        WHERE ANNEE = '2010'
        ) t2
        ON t1.NOM_ETABLISSEMENT = t2.NOM_ETABLISSEMENT
WHERE t1.TAUX_INSERTION > t2.TAUX_INSERTION
AND t1.TAUX_INSERTION <> 'nd' 
AND t1.TAUX_INSERTION <> 'ns' ;

/* Q4 Donner pour chaque départements l’établissement dont le produit du taux d’insertion par le taux
d’emplois stables et par le salaire brut normalisé est le plus élevé.  */



SELECT DISTINCT t3.DEPARTEMENT,t4.NOM_ETABLISSEMENT ,MAX(t3.Produit2) 
from(
        SELECT DISTINCT t2.DEPARTEMENT ,MAX(t2.Produit) as PRODUIT2
        FROM (  SELECT DISTINCT NOM_ETABLISSEMENT, DEPARTEMENT, MAX(CAST(TAUX_INSERTION AS NUMBER)*CAST(TAUX_STABLES AS NUMBER)*CAST(SALAIRE_BRUT_ANNUEL AS NUMBER)) AS Produit
                FROM TPCSV_BRUT
                WHERE TAUX_INSERTION IS NOT NULL 
                      AND TAUX_INSERTION <> 'ns' 
                      AND TAUX_INSERTION <> 'nd'
                      AND TAUX_STABLES IS NOT NULL 
                      AND TAUX_STABLES<>'ns' 
                      AND TAUX_STABLES<>'nd'
                      AND SALAIRE_BRUT_ANNUEL IS NOT NULL
                      AND SALAIRE_BRUT_ANNUEL <> 'ns'  
                      AND SALAIRE_BRUT_ANNUEL <> 'nd'
                GROUP BY DEPARTEMENT,NOM_ETABLISSEMENT 
                ) t1 JOIN (
                                SELECT DISTINCT NOM_ETABLISSEMENT, DEPARTEMENT, MAX(CAST(TAUX_INSERTION AS NUMBER)*CAST(TAUX_STABLES AS NUMBER)*CAST(SALAIRE_BRUT_ANNUEL AS NUMBER)) AS Produit
                                FROM TPCSV_BRUT
                                WHERE TAUX_INSERTION IS NOT NULL 
                                      AND TAUX_INSERTION <> 'ns' 
                                      AND TAUX_INSERTION <> 'nd'
                                      AND TAUX_STABLES IS NOT NULL 
                                      AND TAUX_STABLES<>'ns' 
                                      AND TAUX_STABLES<>'nd'
                                      AND SALAIRE_BRUT_ANNUEL IS NOT NULL
                                      AND SALAIRE_BRUT_ANNUEL <> 'ns'  
                                      AND SALAIRE_BRUT_ANNUEL <> 'nd'
                                GROUP BY DEPARTEMENT,NOM_ETABLISSEMENT 
                                ) t2
        ON t1.NOM_ETABLISSEMENT = t2.NOM_ETABLISSEMENT AND t1.DEPARTEMENT= t2.DEPARTEMENT
        GROUP BY t2.DEPARTEMENT
        ) t3 join (  SELECT DISTINCT NOM_ETABLISSEMENT, DEPARTEMENT, MAX(CAST(TAUX_INSERTION AS NUMBER)*CAST(TAUX_STABLES AS NUMBER)*CAST(SALAIRE_BRUT_ANNUEL AS NUMBER)) AS Produit
                FROM TPCSV_BRUT
                WHERE TAUX_INSERTION IS NOT NULL 
                      AND TAUX_INSERTION <> 'ns' 
                      AND TAUX_INSERTION <> 'nd'
                      AND TAUX_STABLES IS NOT NULL 
                      AND TAUX_STABLES<>'ns' 
                      AND TAUX_STABLES<>'nd'
                      AND SALAIRE_BRUT_ANNUEL IS NOT NULL
                      AND SALAIRE_BRUT_ANNUEL <> 'ns'  
                      AND SALAIRE_BRUT_ANNUEL <> 'nd'
                GROUP BY DEPARTEMENT,NOM_ETABLISSEMENT 
                ) t4 ON t4.PRODUIT = t3.PRODUIT2 AND t3.DEPARTEMENT= t4.DEPARTEMENT group by t3.DEPARTEMENT, t4.NOM_ETABLISSEMENT;

