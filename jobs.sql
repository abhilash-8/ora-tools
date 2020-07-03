-------------------------------------------------------------------------------------------------
--Script Name   : jobs.sql
--Description   : Displays Information about the Jobs and jobs run history 
--Args          : None
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
set echo on 
COL owner FORMAT a15 
COL job_name FORMAT a30
COL job_action FORMAT a50
COL repeat_interval FORMAT a20
COL job_type FORMAT a20
COL state FORMAT a20
COL start_date FORMAT a15
COL last_start_date FORMAT a45
COL next_run_date FORMAT a45
COL actual_start_date FORMAT a45
COL elapsed_time FORMAT a45
set lines 200 pages 200
col last_run_duration for a30
col run_duration for a20
col status for a10
col cpu_used for a18
col ADDITIONAL_INFO_JOBS for a50
select name from v$database;
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
--All Jobs
SELECT owner,job_name,job_type,enabled,state,last_start_date,last_run_duration FROM dba_scheduler_jobs order by owner,last_start_date desc;
--Currently running Jobs
SELECT owner,job_name, session_id, running_instance, elapsed_time, cpu_used FROM dba_scheduler_running_jobs;
--Failed Jobs
select instance_id,owner,job_name,status,error#,cpu_used,ACTUAL_START_DATE,run_duration from dba_scheduler_job_run_details where status not like 'SUCCEEDED' order by ACTUAL_START_DATE;
--Details About a Job
def job_name='&job_name'
select * from (select instance_id,owner,job_name,status,error#,cpu_used,ACTUAL_START_DATE,run_duration from dba_scheduler_job_run_details where  ACTUAL_START_DATE > sysdate - (4/24)  and job_name like '&job_name' order by ACTUAL_START_DATE) where rownum<20;
SELECT owner,job_name,enabled,state,repeat_interval,next_run_date,job_action FROM dba_scheduler_jobs where job_name like '&job_name' ;
select instance_id,owner,job_name,status,ACTUAL_START_DATE,RUN_DURATION from dba_scheduler_job_run_details where  job_name like '&job_name'  order by ACTUAL_START_DATE;
-- Additional Info
--select instance_id,owner,job_name,status,ACTUAL_START_DATE,ADDITIONAL_INFO "ADDITIONAL_INFO_JOBS" from dba_scheduler_job_run_details where  ACTUAL_START_DATE > sysdate - (4/24)  and job_name like '&job_name'  and status not like 'SUCCEEDED' order by ACTUAL_START_DATE;
--select instance_id,owner,job_name,status,ACTUAL_START_DATE,RUN_DURATION from dba_scheduler_job_run_details where  job_name like '&job_name'  order by ACTUAL_START_DATE;
undef job_name
-- Listing older types of dbms_job
col what format a60
set linesize 20
col interval format a40 
set lines 200 pages 200
col schema_user for a10
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
select job,schema_user,failures,last_date,next_date,interval,broken,what from dba_jobs where last_date > (sysdate - (4/24))order by 1;
select * from dba_jobs_running;
