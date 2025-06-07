SELECT
  id AS customer_id,
  COALESCE(gender, 'N/A') AS gender,
  COALESCE(income, 0) AS income,
  age,
  PARSE_DATE('%Y%m%d', CAST(became_member_on AS STRING)) AS became_member_on,
  CURRENT_TIMESTAMP() AS ingested_at
FROM {{ source('starbucks', 'customers') }}
WHERE age < 118
