
# Agent Demo – Natural Language to Metrics

## Example Question
> "Compare CAC and ROAS for last 30 days vs prior 30 days."

## How It Works
This maps to a SQL query that:
- Filters data for the last 60 days
- Splits into two 30-day periods
- Aggregates spend and conversions
- Calculates CAC and ROAS
- Computes % change

## Output Format
```json
{
  "CAC_last_30": 12.34,
  "CAC_prior_30": 10.00,
  "CAC_delta_pct": 23.4,
  "ROAS_last_30": 3.21,
  "ROAS_prior_30": 3.50,
  "ROAS_delta_pct": -8.3
}

