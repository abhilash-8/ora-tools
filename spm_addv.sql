-------------------------------------------------------------------------------------------------
--Script Name   : spm_addv.sql
--Description   : Set up a SQL Plan baseline and let it evolve with better plans [ from 19.22 onwards]
--Args          : @spm_addv <<sql_id>>
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
prompt ### Add Verified SQL Plan Base Line
set serveroutput on
def sql_id=&1
set long 100000
set  tab off
set linesize 200
column report format a150
var report clob
exec :report := dbms_spm.add_verified_sql_plan_baseline('&sql_id');
select :report report from dual;
undef sql_id
