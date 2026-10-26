-------------------------------------------------------------------------------------------------
--Script Name   : js_part.sql
--Description   : Displays size of each partition for a table that contains JSON or CLOB columns
--Args          : @js_part SCHEMA_NAME TABLE_NAME
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

WITH all_partitions AS (
    -- Extracts all table partitions and converts the LONG 'HIGH_VALUE'
    -- into VARCHAR2 so we can legally display and sort by partition_range.
    SELECT
        x.table_owner,
        x.table_name,
        x.partition_name,
        x.partition_position,
        x.high_value AS partition_range
    FROM XMLTABLE(
        '/ROWSET/ROW'
        PASSING DBMS_XMLGEN.getxmltype(
            'SELECT table_owner, table_name, partition_name, partition_position, high_value ' ||
            'FROM dba_tab_partitions ' ||
            'WHERE table_owner = ''' || UPPER('&schema_name') || ''' ' ||
              'AND table_name = ''' || UPPER('&table_name') || ''''
        )
        COLUMNS
            table_owner        VARCHAR2(128)  PATH 'TABLE_OWNER',
            table_name         VARCHAR2(128)  PATH 'TABLE_NAME',
            partition_name     VARCHAR2(128)  PATH 'PARTITION_NAME',
            partition_position NUMBER         PATH 'PARTITION_POSITION',
            high_value         VARCHAR2(4000) PATH 'HIGH_VALUE'
    ) x
),
table_part_sizes AS (
    -- Physical sizes of the table partitions themselves
    SELECT
        owner,
        segment_name AS table_name,
        partition_name,
        bytes
    FROM dba_segments
    WHERE owner = UPPER('&schema_name')
      AND segment_name = UPPER('&table_name')
      AND segment_type = 'TABLE PARTITION'
),
lob_part_sizes AS (
    -- Correctly maps each table partition to its individual physical LOB partition segment
    SELECT
        lp.table_owner AS owner,
        lp.table_name,
        lp.partition_name AS table_partition_name,
        SUM(s.bytes) AS bytes
    FROM dba_lob_partitions lp
    JOIN dba_segments s
      ON s.owner = lp.table_owner
     AND s.segment_name = lp.lob_name
     AND s.partition_name = lp.lob_partition_name
    WHERE lp.table_owner = UPPER('&schema_name')
      AND lp.table_name = UPPER('&table_name')
      AND s.segment_type = 'LOB PARTITION'
    GROUP BY lp.table_owner, lp.table_name, lp.partition_name
)
SELECT
    p.table_owner,
    p.table_name,
    p.partition_name,
    p.partition_range,
    ROUND(NVL(t.bytes, 0) / 1024 / 1024, 2) AS table_part_size_mb,
    ROUND(NVL(l.bytes, 0) / 1024 / 1024, 2) AS lob_part_size_mb,
    ROUND((NVL(t.bytes, 0) + NVL(l.bytes, 0)) / 1024 / 1024, 2) AS total_size_mb
FROM all_partitions p
LEFT JOIN table_part_sizes t
  ON p.table_owner = t.owner
 AND p.table_name = t.table_name
 AND p.partition_name = t.partition_name
LEFT JOIN lob_part_sizes l
  ON p.table_owner = l.owner
  AND p.table_name = l.table_name
  AND p.partition_name = l.table_partition_name
ORDER BY p.partition_range ASC;

undef schema_name
undef table_name
