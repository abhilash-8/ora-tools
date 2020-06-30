-------------------------------------------------------------------------------------------------
--Script Name   : info.sql
--Description   : Displays Information about the Oracle database environment
--Args          : None
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
SET NEWPAGE NONE
SET PAGESIZE 0
SET SPACE 0
SET LINESIZE 16000
SET VERIFY OFF
SET TRIMOUT ON
SET TRIMSPOOL ON
SET COLSEP |
COLUMN table_name for a18
COLUMN column_name for a18
COLUMN index_name for a18
COLUMN owner for a18
COLUMN host for a18
COLUMN file_name format a40
COLUMN tablespace_name format a18
COLUMN directory_name FORMAT A25
COLUMN directory_path FORMAT A80
col sql_handle for a25
col plan_name for a30
col plan_name for a30
col sql_text for a30
col module for a20
col last_executed for a35
col last_modified for a35
col last_verified for a35
col alert_log for a120
col FLASHBACK_ON for a15
col FORCE_LOGGING for a15
col STATUS for a15
col HOSTNAME for a20
col LOG_MODE for a15
col FILE_TYPE for a20
col RESOURCE_NAME for a10
col first_seen for a30
col last_seen for a30
col open_mode for a20
col database_role for a20
set serveroutput on
set time on
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
set lines 2000
set pages 2000
SET SQLBL OFF
col directory_name format a40
col value format a80
set echo on
select instance_name, status, host_name, version, startup_time from gv$instance;
select dbid, name, db_unique_name,flashback_on,force_logging,log_mode, open_mode, database_role, sysdate from gv$database;
show parameter control_management_pack_access
show parameter diag
show parameter background
select * from v$flash_Recovery_area_usage;
show parameter reco
set lines 200 pages 200
col db_link format a40
select inst_id,resource_name, current_utilization, max_utilization from gv$resource_limit where resource_name in ('processes','sessions');
select vd.value||'/alert_'||vi.instance_name||'.log' "alert_log" from v$diag_info vd ,gv$instance vi where vd.name like 'Diag Trace';
select * from v$version;
set time off
set echo off
set lines 227 pages 1000 long 1000000 longchunksize 196 timing on serveroutput on size 1000000 trimspool on sqlprompt '&_CONNECT_IDENTIFIER> '
