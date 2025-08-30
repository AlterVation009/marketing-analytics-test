
-- Your desired date range
DECLARE start_date DATE DEFAULT '2025-05-01';
DECLARE end_date DATE DEFAULT '2025-05-30';

-- Calculate CAC and ROAS for the selected date range
SELECT
  ROUND(SAFE_DIVIDE(SUM(spend), SUM(conversions)), 2) AS cac,
  ROUND(SAFE_DIVIDE(SUM(conversions) * 100, SUM(spend)), 2) AS roas
FROM `n8n_data.ads_spend`
WHERE DATE(date) BETWEEN start_date AND end_date;
