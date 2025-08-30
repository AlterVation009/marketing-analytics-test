# marketing-analytics-test
This repository contains the implementation of a marketing analytics pipeline focused on ingesting ad spend data, modeling key performance indicators (CAC and ROAS), and exposing metrics for analyst access. Includes SQL logic for comparing performance across time periods and a natural-language mapping demo.

---

## 📦 Part 1 – Ingestion (Foundation)

**Dataset:** `ads_spend.csv`

**Columns:**
- date, platform, account, campaign, country, device, spend, clicks, impressions, conversions

**Tools Used:**
- n8n for orchestration
- BigQuery as data warehouse

**Workflow:**
- Load CSV into n8n by an http request
- Extract info from binary file
- Add metadata: `load_date`, `source_file_name`
- Ensure data persists after refresh

---

## 📊 Part 2 – KPI Modeling (SQL)

**Metrics:**
- **CAC** = spend / conversions
- **ROAS** = (conversions × 100) / spend

**Analysis:**
- Compare last 30 days vs prior 30 days
- Based on max date in dataset

**SQL Logic:**
- Get the max date from the dataset and calculate date ranges
- Filter data within the last 60 days
- Aggregate metrics for each 30-day period
- Compare metrics between the two periods

---

## 📈 Part 3 – Analyst Access

**Method:** Parameterized SQL Script

```sql
DECLARE start_date DATE DEFAULT '2025-05-01';
DECLARE end_date DATE DEFAULT '2025-05-30';

SELECT
  SAFE_DIVIDE(SUM(spend), SUM(conversions)) AS cac,
  SAFE_DIVIDE(SUM(conversions) * 100, SUM(spend)) AS roas
FROM `your_project.your_dataset.ads_spend`
WHERE DATE(date) BETWEEN start_date AND end_date;
```

Analysts can modify `start_date` and `end_date` to retrieve metrics for any period.

