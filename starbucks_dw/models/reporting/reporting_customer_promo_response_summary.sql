{{ config(
    materialized = 'table'
) }}

SELECT
  income,
  gender,
  age,
  COUNT(*) AS total_customers,
  COUNTIF(promo_trans_count > 0) AS responded_customers,
  AVG(pct_promo_response) AS avg_response_rate,
  SAFE_DIVIDE(COUNTIF(promo_trans_count > 0), COUNT(*)) AS pct_customers_responded
FROM {{ ref('reporting_customer_promo_response_base') }}
GROUP BY income, gender, age
ORDER BY pct_customers_responded DESC
