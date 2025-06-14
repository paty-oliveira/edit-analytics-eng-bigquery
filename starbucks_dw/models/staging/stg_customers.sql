{{
    config(
        materialized='view'
    )
}}

SELECT
    id as customer_id,
    COALESCE(gender, 'N/A') as gender,
    COALESCE(income, 0) as income,
    age,
    PARSE_DATETIME('%Y%m%d', CAST(became_member_on AS STRING)) as subscribed_date,
    current_timestamp() as ingested_at
FROM {{ source('starbucks', 'customers') }}
WHERE  age != 118
