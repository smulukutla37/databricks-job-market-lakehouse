CREATE OR REFRESH MATERIALIZED VIEW gold_company_hiring
COMMENT 'Which companies are hiring the most, and how many jobs are remote'
AS SELECT
  company,
  COUNT(*)                                                 AS total_jobs,
  SUM(CASE WHEN remote THEN 1 ELSE 0 END)                  AS remote_jobs,
  ROUND(100 * AVG(CASE WHEN remote THEN 1 ELSE 0 END), 1)  AS remote_pct,
  COUNT(DISTINCT location)                                 AS locations,
  CAST(MAX(_processed_at) AS DATE)                         AS last_updated
FROM silver_jobs
WHERE has_company = true
GROUP BY company;