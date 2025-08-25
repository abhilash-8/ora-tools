-------------------------------------------------------------------------------------------------
--Script Name   : spm_list.sql
--Description   : Identifies the list of SQL Plan Baselines 
--Args          : @spm_list <<sql_id>>
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
def sql_id=&1
set lines 500 pages 500
col sql_id format a14
col sql_plan_baseline format a30
col plan_hash_value format 999999999999999
col exact_matching_signature format 99999999999999999999
col sql_text format a50
col enabled for a10
col accepted for a10
col fixed for a10
--prompt ### SQL PLan from Cursor
--select * from table(dbms_xplan.display_cursor('&sql_id',format=>'ALLSTATS LAST +cost +bytes'));

prompt ### Current SQL Baselines
select inst_id,sql_id,
plan_hash_value,
sql_plan_baseline,
executions,
elapsed_time,
exact_matching_signature,
substr(sql_text,0,50) sql_text
from gv$sql
where parsing_schema_name != 'SYS'
and sql_id like '&sql_id' ;

SELECT sql_handle,
       plan_name,
       ENABLED,
       ACCEPTED,
       FIXED,
       Created
  FROM dba_sql_plan_baselines
 WHERE signature IN (SELECT exact_matching_signature
                       FROM v$sql
                      WHERE sql_id = '&sql_id');
