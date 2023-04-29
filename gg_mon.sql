-------------------------------------------------------------------------------------------------
--Script Name   : jobs.sql
--Description   : Displays Information about the Jobs and jobs run history 
--Args          : None
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
spool gg_mon.out
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
set lines 200 pages 200
set pages 500
col table_owner for a20
col table_name for a38
col truncated for a15
col timestamp for a20
col inserts for 9999999999
col updates for 9999999999
col deletes  for 9999999999
col TRUNC for a3
set numwidth 20
col LAG_MINS for 999999999
col PARTITION_NAME for a35
set echo on
select * from
(
select table_owner,timestamp,count(*) TABLES_REPLICATED from dba_tab_modifications where table_owner in
(
--- append your list of users here , below is an example
	'BUSS_USER',
	'MOBI_USER'
)
and timestamp > sysdate-(1/24)
group by table_owner,timestamp
order by TIMESTAMP
);
spool off 
