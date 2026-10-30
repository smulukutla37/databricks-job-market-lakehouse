CREATE OR REFRESH STREAMING TABLE bronze_job_postings
COMMENT 'Raw job postings, loaded incrementally from the daily CSV files'
AS SELECT
  *,
  current_timestamp()  AS _ingested_at,
  _metadata.file_path  AS _source_file
FROM STREAM read_files(
  '/Volumes/workspace/default/raw/neo4j_query_table_data_*.csv',
  format    => 'csv',
  header    => true,
  multiLine => true,
  escape    => '"'
);