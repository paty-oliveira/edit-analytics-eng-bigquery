SELECT
id as customer_id,
coalesce(gender, 'N/A') as gender,
coalesce(income, 0) as income,
age,
parse_date('%Y%m%d', cast(became_member_on as string)) as become_member_on,
current_timestamp() as ingested_at
FROM {{ source ('starbucks','customers')}}
where age != 118
