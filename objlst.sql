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
col TABLES              for 9999999
col TABLEPARTITION      for 9999999
col INDEXES             for 9999999
col INDEXPARTITION      for 9999999
col VIEWS               for 9999999
col TRIGGERS            for 9999999
col PACKAGEBODY         for 9999999
col PACKAGES            for 9999999
col PROCEDURES          for 9999999
col FUNCTIONS           for 9999999
col SEQUENCES           for 9999999
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

prompt ### Dependencies of INVALID Objects found 
col REF_OWNER    for a10
col REF_LINK     for a8
col REF_NAME     for a35 trunc
col REF_TYPE     for a15
col DEP_TYPE     for a10

select owner,name,type,referenced_owner ref_owner,referenced_type ref_type , referenced_name ref_name ,referenced_link_name ref_link , dependency_type dep_type 
from dba_dependencies dp
where dp.name in (select object_name from dba_objects where status like 'INVALID');

