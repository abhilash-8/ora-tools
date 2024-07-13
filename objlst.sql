-------------------------------------------------------------------------------------------------
--Script Name    : objlst.sql
--Description    : Shows a summary of database objects for various database users 
--Args           : @objlst
--Author         : Abhilash Kumar Bhattaram
--Email          : abhilash8@gmail.com     
--GitHb          : https://github.com/abhilash-8/objlst
-------------------------------------------------------------------------------------------------
set lines 500 pages 500
col owner for a25
compute sum of TABLES TABLEPARTITION   INDEXES INDEXPARTITION VIEWS TRIGGERS PACKAGEBODY PACKAGES PROCEDURES FUNCTIONS SEQUENCES OBJECT_COUNT on report
break on report on _date

prompt ### All Objects 
select owner,object_type,count(*) "OBJECT_COUNT"
from dba_objects where owner in (select username from dba_users where oracle_maintained='N')
group by owner,object_type order by owner,object_type;

prompt ### Frequently Used Objects  
--compute sum of TABLES TABLEPARTITION   INDEXES INDEXPARTITION VIEWS TRIGGERS PACKAGEBODY PACKAGES PROCEDURES FUNCTIONS SEQUENCES on report
--break on report on _date
select owner,
max( decode( object_type, 'TABLE', cnt, null ) ) Tables,
max( decode( object_type, 'TABLE PARTITION', cnt, null ) ) TABLEPARTITION,
max( decode( object_type, 'INDEX', cnt, null ) ) Indexes,
max( decode( object_type, 'INDEX PARTITION', cnt, null ) ) Indexpartition,
max( decode( object_type, 'VIEW', cnt, null ) ) Views,
max( decode( object_type, 'TRIGGER', cnt, null ) ) triggers,
max( decode( object_type, 'PACKAGE BODY', cnt, null ) ) packagebody,
max( decode( object_type, 'PACKAGE', cnt, null ) ) packages,
max( decode( object_type, 'PROCEDURE', cnt, null ) ) PROCEDURES,
max( decode( object_type, 'FUNCTION', cnt, null ) ) FUNCTIONS,
max( decode( object_type, 'SEQUENCE', cnt, null ) ) SEQUENCES
from ( select owner, object_type, count(*) cnt
from dba_objects o,dba_users u
where o.owner=u.username and u.oracle_maintained='N' 
group by owner, object_type )
group by owner;


prompt ### Valid / Invalid Count 

with 
w1 as 
(
select count(*) VALID 
from dba_objects o,dba_users u
where o.owner=u.username and u.oracle_maintained='N' and o.status='VALID'
),
w2 as 
(
select count(*) INVALID 
from dba_objects o,dba_users u
where o.owner=u.username and u.oracle_maintained='N' and o.status='INVALID'
)
select w1.VALID,w2.INVALID,(w1.valid+w2.invalid) total from w1,w2;



prompt ### Which objects are INVALID ?
--compute sum of TABLES TABLEPARTITION   INDEXES INDEXPARTITION VIEWS TRIGGERS PACKAGEBODY PACKAGES PROCEDURES FUNCTIONS SEQUENCES on report
--break on report on _date
select owner,
max( decode( object_type, 'TABLE', cnt, null ) ) Tables,
max( decode( object_type, 'TABLE PARTITION', cnt, null ) ) TABLEPARTITION,
max( decode( object_type, 'INDEX', cnt, null ) ) Indexes,
max( decode( object_type, 'INDEX PARTITION', cnt, null ) ) Indexpartition,
max( decode( object_type, 'VIEW', cnt, null ) ) Views,
max( decode( object_type, 'TRIGGER', cnt, null ) ) triggers,
max( decode( object_type, 'PACKAGE BODY', cnt, null ) ) packagebody,
max( decode( object_type, 'PACKAGE', cnt, null ) ) packages,
max( decode( object_type, 'PROCEDURE', cnt, null ) ) PROCEDURES,
max( decode( object_type, 'FUNCTION', cnt, null ) ) FUNCTIONS,
max( decode( object_type, 'SEQUENCE', cnt, null ) ) SEQUENCES
from ( select owner, object_type, count(*) cnt
from dba_objects o,dba_users u
where o.owner=u.username and u.oracle_maintained='N' and o.status like 'INVALID'
group by owner, object_type )
group by owner;


prompt ### What objects are INVALID ?
col object_name for a50
select owner,object_name,object_type from dba_objects where status like 'INVALID';



