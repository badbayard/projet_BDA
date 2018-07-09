/*Yannis Hutt 11408376 Julien Granjon 11509496 */

--------------------------------------------------------------------------------
--              LIFBDW2 - 2017-2018 Printemps - TPCSV - ANALYSE
--------------------------------------------------------------------------------
set serveroutput on;

---------------------------------------------------------------
-- Exercice 1
---------------------------------------------------------------
---------------------------------------------------------------
-- Exercice 2
---------------------------------------------------------------
-------------
-- Ex2 Q1
-------------

Select count(distinct Identifiant) 
from TPCSV_brut;

/* 78 identifiants distincts*/

Select count (*)
from TPCSV_brut t1 join TPCSV_brut t2 ON t1.identifiant = t2.identifiant 
AND t1.nom_etablissement <> t2.nom_etablissement;

/* 0 retour */


-------------
-- Ex2 Q2
-------------
Select count(nom_etablissement),count(Annee),count(academie), count(nom_domaine),  count(NOM_DISCIPLINE)
From TPCSV_BRUT
Where TAUX_INSERTION is not null 
AND Taux_insertion <> 'ns';

/*1164 pour etablissement,année, nom_domaine,nom_discipline, 1087 pour academie*/

/* résultats :
#tuples           : 2025
#établissements   : 1164
#années           : 1164
#académies        : 1087
#domaines         : 1164 
#disciplines      : 1164
*/

-------------
-- Ex2 Q3
-------------

/*
  CODE_DOMAINE    ?-> NOM_DOMAINE           Non respecter
  NOM_DOMAINE     ?-> CODE_DOMAINE          Respecter          
  CODE_DISCIPLINE ?-> NOM_DISCIPLINE        Respecter
  NOM_DISCIPLINE  ?-> CODE_DISCIPLINE       Respecter
  CODE_DISCIPLINE ?-> CODE_DOMAINE          Respecter
  CODE_DOMAINE    ?-> CODE_DISCIPLINE       Respecter
*/

SELECT COUNT(*) AS DF1_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON (t1.NOM_DOMAINE = t2.NOM_DOMAINE) 
AND t1.CODE_DOMAINE <> t2.CODE_DOMAINE;
 
SELECT COUNT(*) AS DF1_2
FROM TPCSV_BRUT t1 FULL OUTER JOIN TPCSV_BRUT t2 
ON (t1.CODE_DOMAINE = t2.CODE_DOMAINE) 
AND t1.NOM_DOMAINE <> t2.NOM_DOMAINE;

SELECT COUNT(*) AS DF2_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON (t1.NOM_DISCIPLINE = t2.NOM_DISCIPLINE)
AND t1.CODE_DISCIPLINE <> t2.CODE_DISCIPLINE; 

SELECT COUNT(*) AS DF2_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON (t1.CODE_DISCIPLINE = t2.CODE_DISCIPLINE)
AND t1.NOM_DISCIPLINE <> t2.NOM_DISCIPLINE;


SELECT COUNT(*)AS DF3_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_DISCIPLINE = t2.CODE_DISCIPLINE
AND t1.CODE_DOMAINE <> t2.CODE_DOMAINE;

SELECT COUNT(*)AS DF3_1
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.CODE_DOMAINE = t2.CODE_DOMAINE 
AND t1.CODE_DISCIPLINE <> t2.CODE_DISCIPLINE;

-------------
-- Ex2 Q4
-------------

/*clé minimal = nom_discipline*/
SELECT COUNT(*)
FROM TPCSV_BRUT t1 JOIN TPCSV_BRUT t2 
ON t1.nom_discipline = t2.NOM_DISCIPLINE 
where t1.CODE_DISCIPLINE <> t2.CODE_DISCIPLINE OR t1.code_domaine <> t2.code_domaine OR t2.nom_discipline <> t1.NOM_DISCIPLINE;

---------------------------------------------------------------
-- Exercice 3
---------------------------------------------------------------
-------------
-- Ex3 Q1
-------------
Select nom_discipline
from TPCSV_BRUT
where annee = 2011
minus (
    Select nom_discipline
    from TPCSV_BRUT
    where annee = 2010
    );
    
    /*Liste discipline :
    
    -Masters enseignement
    -Masters enseignement : premier degrÃ©
    -Masters enseignement : second degrÃ©, CPE... */
    
 
-------------
-- Ex3 Q2
-------------

Select SUM(NB_reponses) 
FROM TPCSV_BRUT
where code_discipline = 'disc18'
UNION ALL
Select SUM(rep1)
FROM (  Select SUM(NB_reponses) AS rep1
        FROM TPCSV_BRUT
        where code_discipline = 'disc19'
        UNION
        Select SUM(NB_reponses) AS rep1
        FROM TPCSV_BRUT
        where code_discipline = 'disc20'
    );
---------------------------------------------------------------
-- Exercice 4
---------------------------------------------------------------
-------------
-- Ex4 Q1
-------------
SELECT distinct Code_domaine, Min(code_discipline) as code_discipline, count( distinct code_discipline)-1 as NB_disc
FROM TPCSV_BRUT
group by code_domaine
having count(distinct code_discipline)>1
order by CODE_DISCIPLINE;

-------------
-- Ex4 Q2
-------------

Select distinct nom_discipline
from TPCSV_BRUT t1 join Discipline_aggregats t2 on (t1.code_discipline = t2.code_discipline)
where t1.nom_discipline LIKE 'Ensemble%';

-------------
-- Ex4 Q3
-------------

create or replace view Domaine_2 AS
select distinct t1.annee,t1.nom_domaine,t1.code_discipline,max(t1.nb_insert) as nbmax
from Domaine_1 t1 join (
                    Select annee,nom_domaine,max(nb_insert) as nbmax1
                    from  Domaine_1 
                    group by annee,nom_domaine
                    ) t2 
                    on t1.annee = t2.annee and t1.nom_domaine = t2.nom_domaine and nbmax1=t1.NB_INSERT
group by t1.nom_domaine,t1.annee,t1.code_discipline;

create or replace view Domaine_1 AS
select distinct t1.annee, t1.nom_domaine,t1.code_discipline, AVG( CAST(t1.taux_insertion AS number)) AS nb_insert
from TPCSV_BRUT t1 right join (select taux_insertion from TPCSV_BRUT where taux_insertion <> 'ns' AND taux_insertion <> 'nd') t2 
on t1.taux_insertion=t2.taux_insertion
group by t1.nom_domaine,t1.code_discipline,t1.annee;




create or replace view Domaine_aggregat AS
select distinct t3.annee, t3.nom_domaine,t3.code_discipline,t4.nom_etablissement
from (
        select distinct t2.annee, t2.nom_domaine,t2.code_discipline,max( CAST(t1.taux_insertion AS number)) as tauxinsertion
        from TPCSV_BRUT t1 right join Domaine_2 t2
        on t1.annee = t2.annee and t1.nom_domaine = t2.nom_domaine and t1.code_discipline = t2.code_discipline
        where taux_insertion <> 'ns' AND taux_insertion <> 'nd'
        group by  t2.annee, t2.nom_domaine, t2.code_discipline
        ) t3 left join TPCSV_BRUT t4
    on t3.annee = t4.annee and t3.nom_domaine = t4.nom_domaine and t3.code_discipline = t4.code_discipline and tauxinsertion = CAST(t4.taux_insertion AS number)
    where t4.taux_insertion <> 'ns' AND t4.taux_insertion <> 'nd';



---------------------------------------------------------------
-- Exercice 5
---------------------------------------------------------------
-------------
-- Ex5 Q1
-------------
/*
V�rifier que l�universit� fictive UNIV a bien toutes les combinaisons de couples ANNEE et CODE_DISCIPLINE
de la base.*/

select distinct count(*)
from (select distinct annee, code_discipline
from TPCSV_BRUT
where identifiant = 'UNIV');

select distinct count(*)
from (select distinct annee, code_discipline
from TPCSV_BRUT);

/* Les deux retournes 37 */

-------------
-- Ex5 Q2
-------------
/*D�finir une une vue UNIV_AGGREGATS qui, pour chaque couple ANNEE et CODE_DISCIPLINE, va v�rifier
que l�aggr�gation est correctement r�alis�e. Pour cela,
� NB_REPONSES_UNIV le nombre de r�ponses de l�universit� fictive UNIV ; 121217
� NB_REPONSES_NON_UNIV le nombre total de r�ponses des universit�s r�elles ;  121157
� DELTA_NB_REPONSES l��cart entre les deux valeurs pr�c�dentes. 60
� TAUX_REPONSES_UNIV le taux de r�ponse de l�universit� fictive UNIV ; 2645
� TAUX_REPONSES_NON_UNIV le taux de r�ponse des universit�s r�elles ; 138673
� DELTA_TAUX_REPONSES l��cart entre les deux pr�c�dents.  136028 */

SELECT DISTINCT SUM(NB_REPONSES) AS NB_REPONSES_UNIV
FROM TPCSV_BRUT
WHERE IDENTIFIANT = 'UNIV';  /*121217*/
        
SELECT DISTINCT SUM(NB_REPONSES) AS NB_REPONSES_NON_UNIV
FROM TPCSV_BRUT
WHERE IDENTIFIANT <> 'UNIV';  /*121157*/



Select NB_REPONSES_UNIV-NB_REPONSES_NON_UNIV AS DELTA_NB_REPONSES
from (SELECT DISTINCT SUM(NB_REPONSES) AS NB_REPONSES_UNIV
      FROM TPCSV_BRUT
      WHERE IDENTIFIANT = 'UNIV'
      ) natural join (SELECT DISTINCT SUM(NB_REPONSES) AS NB_REPONSES_NON_UNIV
                      FROM TPCSV_BRUT
                      WHERE IDENTIFIANT <> 'UNIV'
                     ); 
                     
                     /*reponse 60*/
                     
/*TAUX_REPONSES_UNIV le taux de réponse de l’université fictive UNIV;
—
TAUX_REPONSES_NON_UNIV le taux de réponse des universités réelles ;
—
DELTA_TAUX_REPONSES l’écart entre les deux précédents */                     
                     
                     

SELECT DISTINCT SUM(TAUX_REPONSE) AS TAUX_REPONSES_UNIV
FROM TPCSV_BRUT
WHERE IDENTIFIANT = 'UNIV';  /*2645*/



SELECT DISTINCT SUM(TAUX_REPONSE) AS TAUX_REPONSES_NON_UNIV
FROM TPCSV_BRUT
WHERE IDENTIFIANT <> 'UNIV';  /*138673*/


Select TAUX_REPONSES_NON_UNIV-TAUX_REPONSES_UNIV AS DELTA_TAUX_REPONSES
from (SELECT DISTINCT SUM(TAUX_REPONSE) AS TAUX_REPONSES_UNIV
      FROM TPCSV_BRUT
      WHERE IDENTIFIANT = 'UNIV'
      ) natural join (SELECT DISTINCT SUM(TAUX_REPONSE) AS TAUX_REPONSES_NON_UNIV
                      FROM TPCSV_BRUT
                      WHERE IDENTIFIANT <> 'UNIV'
                     );   /* 136028*/
                     
                     
create or replace view Univ_aggregat AS   
Select distinct annee, code_discipline,NB_REPONSES_UNIV-NB_REPONSES_NON_UNIV as DELTA_NB_REPONSES,TAUX_REPONSES_NON_UNIV-TAUX_REPONSES_UNIV AS DELTA_TAUX_REPONSES
from (Select DISTINCT annee, code_discipline,NB_REPONSES_UNIV,NB_REPONSES_NON_UNIV
          from (SELECT DISTINCT annee, code_discipline,SUM(NB_REPONSES) AS NB_REPONSES_UNIV
          FROM TPCSV_BRUT
          WHERE IDENTIFIANT = 'UNIV' group by annee, code_discipline
          ) natural join (SELECT DISTINCT annee, code_discipline,SUM(NB_REPONSES) AS NB_REPONSES_NON_UNIV
                          FROM TPCSV_BRUT
                          WHERE IDENTIFIANT <> 'UNIV' group by annee, code_discipline
                         )
    ) natural join ( Select DISTINCT annee, code_discipline,TAUX_REPONSES_NON_UNIV,TAUX_REPONSES_UNIV
                    from (SELECT DISTINCT annee, code_discipline,SUM(TAUX_REPONSE) AS TAUX_REPONSES_UNIV
                          FROM TPCSV_BRUT
                          WHERE IDENTIFIANT = 'UNIV' group by annee, code_discipline
                          ) natural join (SELECT DISTINCT annee, code_discipline,SUM(TAUX_REPONSE) AS TAUX_REPONSES_NON_UNIV
                                          FROM TPCSV_BRUT
                                          WHERE IDENTIFIANT <> 'UNIV' group by annee, code_discipline
                                         )
                    ); 

-------------
-- Ex5 Q3
-------------

Select *
from Univ_aggregat
where DELTA_NB_REPONSES <> 0
or  DELTA_TAUX_REPONSES <> 0;

/* L'ensemble de la table semble comporté des incohérences */



