SELECT
  id AS customer_id,
  IFNULL(gender, 'N/A') AS gender,
  IFNULL(income, 0) AS income,
  PARSE_DATE('%Y%m%d', CAST(became_member_on AS STRING)) AS subscribed_date,
  age,
  CURRENT_TIMESTAMP() AS ingested_at
FROM
    {{ source('starbucks', 'customers') }}
WHERE
  age <> 118
