CREATE OR REFRESH STREAMING TABLE silver_jobs (
  -- Hard rules: bad rows are DROPPED
  CONSTRAINT valid_job_id  EXPECT (job_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_title   EXPECT (title  IS NOT NULL) ON VIOLATION DROP ROW,

  -- Soft rules: rows are KEPT, but violations are counted
  CONSTRAINT has_company   EXPECT (company IS NOT NULL),
    CONSTRAINT data_related  EXPECT (title RLIKE '(?i)(data|etl|analyt|sql|business intelligence|power bi|tableau|warehouse|machine learning|reporting|qlik|spotfire|dashboard|\\bbi\\b(?![-/]))') ON VIOLATION DROP ROW
)
COMMENT 'Cleaned job postings with data-quality checks'
AS SELECT
  trim(job_id)                    AS job_id,
  trim(title)                     AS title,
  nullif(trim(company), '')       AS company,
  trim(location)                  AS location,
  trim(work_type)                 AS work_type,
  try_cast(remote AS BOOLEAN)     AS remote,
  url,
  description,
  nullif(trim(company), '') IS NOT NULL AS has_company,
  _ingested_at,
  _source_file,
  current_timestamp()             AS _processed_at
FROM STREAM(bronze_job_postings);