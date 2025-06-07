WITH cleaned_customers AS (
  SELECT
    -- Rename id to customer_id
    id AS customer_id,

    -- Replace NULL gender with 'N/A'
    COALESCE(gender, 'N/A') AS gender,

    -- Remove invalid age = 118
    CASE
      WHEN age = 118 THEN NULL
      ELSE age
    END AS age,

    -- Replace NULL income with 0
    COALESCE(income, 0) AS income,

    -- Cast become_member_on to DATE (format: YYYYMMDD)
    PARSE_DATE('%Y%m%d', CAST(became_member_on AS STRING)) AS subscribed_date,

    -- Add ingested_at column with current timestamp
    CURRENT_TIMESTAMP() AS ingested_at
  FROM {{ source('starbucks', 'customers') }}

  -- Remove rows with age=118 (like a placeholder for missing)
  WHERE age != 118 OR age IS NULL
)

SELECT *
FROM cleaned_customers