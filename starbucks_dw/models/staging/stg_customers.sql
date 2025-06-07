SELECT
id as customer_id,
COALESCE(gender,'N/A') as gender,
COALESCE(income,0) as income,
age,
PARSE_DATE('%Y%m%d', CAST(became_member_on AS STRING)) as became_member_on,
current_timestamp() as ingested_at
FROM {{ source('starbucks', 'customers')}}
WHERE AGE < 118
