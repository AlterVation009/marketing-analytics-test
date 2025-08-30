
-- Step 1: Get the max date from the dataset and calculate date ranges
WITH date_bounds AS (
  SELECT
    MAX(DATE(date)) AS end_date,
    DATE_SUB(MAX(DATE(date)), INTERVAL 30 DAY) AS start_last_30,
    DATE_SUB(MAX(DATE(date)), INTERVAL 60 DAY) AS start_prior_30
  FROM `n8n_data.ads_spend`
),

-- Step 2: Filter data within the last 60 days
base_data AS (
  SELECT
    DATE(date) AS day,
    spend,
    conversions
  FROM `n8n_data.ads_spend`,
       date_bounds
  WHERE DATE(date) BETWEEN start_prior_30 AND end_date
),

-- Step 3: Aggregate metrics for each 30-day period
metrics AS (
  SELECT
    CASE 
      WHEN day > (SELECT start_last_30 FROM date_bounds) THEN 'last_30_days'
      ELSE 'prior_30_days'
    END AS period,
    SUM(spend) AS total_spend,
    SUM(conversions) AS total_conversions,
    SAFE_DIVIDE(SUM(spend), SUM(conversions)) AS cac,
    SAFE_DIVIDE(SUM(conversions) * 100, SUM(spend)) AS roas
  FROM base_data
  GROUP BY period
),

-- Step 4: Compare metrics between the two periods
comparison AS (
  SELECT
    MAX(IF(period = 'last_30_days', cac, NULL)) AS cac_last_30,
    MAX(IF(period = 'prior_30_days', cac, NULL)) AS cac_prior_30,
    MAX(IF(period = 'last_30_days', roas, NULL)) AS roas_last_30,
    MAX(IF(period = 'prior_30_days', roas, NULL)) AS roas_prior_30
  FROM metrics
)

-- Step 5: Final output with percentage change
SELECT
  ROUND(cac_last_30, 2) AS cac_last_30,
  ROUND(cac_prior_30, 2) AS cac_prior_30,
  ROUND(SAFE_DIVIDE(cac_last_30 - cac_prior_30, cac_prior_30) * 100, 2) AS cac_delta_pct,
  ROUND(roas_last_30, 2) AS roas_last_30,
  ROUND(roas_prior_30, 2) AS roas_prior_30,
  ROUND(SAFE_DIVIDE(roas_last_30 - roas_prior_30, roas_prior_30) * 100, 2) AS roas_delta_pct
FROM comparison;