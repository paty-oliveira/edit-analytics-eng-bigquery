{{ config(enabled=false) }}

select
    1 as customer_id,
    "F" as gender,
    10 as age,
    0 as income,
    current_timestamp as subscribed_date,
    current_timestamp as ingested_at
union all
select
    2 as cutomer_id,
    "F" as gender,
    10 as age,
    0 as income,
    current_timestamp as subscribed_date,
    current_timestamp as ingested_at
