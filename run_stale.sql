-------------------------------------------------------------------------------------------------
--Script Name   : run_stale.sql
--Description   : Generate DDL for Stale Stats updates for the specified Schemas
--Args          : None
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
set lines 500 pages 1000
col "STALE_STATS" for a500
set verify off
set head off
set feedback off
set time off
set timing off
set serveroutput off
spool temp_stats_run_consolidated.sql

select distinct(STALE_STATS) from
(
select 'EXECUTE DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>'||''''||owner||''''||' , TABNAME =>'||''''||table_name||''''||' ,OPTIONS =>'||''''||'GATHER AUTO'||''''||' , CASCADE =>'||'TRUE'||' , DEGREE =>'||'8'||' , METHOD_OPT =>'||''''||'FOR ALL COLUMNS SIZE AUTO'||''''||'); ' "STALE_STATS" from dba_tab_statistics where STALE_STATS='YES' and owner
like 'OE'
order by num_rows desc
);

select distinct(STALE_STATS) from
(
select 'EXECUTE DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>'||''''||owner||''''||' , TABNAME =>'||''''||table_name||''''||' ,OPTIONS =>'||''''||'GATHER AUTO'||''''||' , CASCADE =>'||'TRUE'||' , DEGREE =>'||'8'||' , METHOD_OPT =>'||''''||'FOR ALL COLUMNS SIZE AUTO'||''''||'); ' "STALE_STATS" from dba_tab_statistics where STALE_STATS='YES' and owner
like 'HR'
order by num_rows desc
);

spool off
set feedback on
set head on
