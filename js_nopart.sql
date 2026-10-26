-------------------------------------------------------------------------------------------------
--Script Name   : js_nopart.sql
--Description   : Displays size of a table that contains JSON or CLOB columns
--Args          : @js_nopart SCHEMA_NAME TABLE_NAME
--Author        : Abhilash Kumar Bhattaram
--Email         : abhilash8@gmail.com                                           
-------------------------------------------------------------------------------------------------
col partition_range for a90
col partition_name for a20
col  table_owner for a20

col table_part_size_mb for 999,999,999,999,999
col lob_part_size_mb for 999,999,999,999,999
col total_size_mb for 999,999,999,999,999

def schema_name=&1
def table_name=&2

compute sum of total_size_mb on report
break on report

WITH table_size AS (
    -- Physical size of the base non-partitioned table
    SELECT
        owner,
        segment_name AS table_name,
        bytes
    FROM dba_segments
    WHERE owner = UPPER('&schema_name')
      AND segment_name = UPPER('&table_name')
      AND segment_type = 'TABLE'
),
lob_sizes AS (
    -- Physical size of all LOB/JSON columns combined (aggregated)
    SELECT
        s.owner,
        tab.table_name,
        SUM(s.bytes) AS bytes
    FROM dba_segments s
    JOIN dba_lobs tab
      ON s.owner = tab.owner
     AND s.segment_name = tab.segment_name
    WHERE s.owner = UPPER('&schema_name')
      AND tab.table_name = UPPER('&table_name')
      AND s.segment_type = 'LOBSEGMENT'
    GROUP BY s.owner, tab.table_name
)
SELECT
    NVL(t.owner, l.owner) AS table_owner,
    NVL(t.table_name, l.table_name) AS table_name,
    ROUND(NVL(t.bytes, 0) / 1024 / 1024, 2) AS table_size_mb,
    ROUND(NVL(l.bytes, 0) / 1024 / 1024, 2) AS lob_size_mb,
    ROUND((NVL(t.bytes, 0) + NVL(l.bytes, 0)) / 1024 / 1024, 2) AS total_size_mb
FROM table_size t
FULL OUTER JOIN lob_sizes l
  ON t.owner = l.owner
 AND t.table_name = l.table_name;

undef schema_name
undef table_name
