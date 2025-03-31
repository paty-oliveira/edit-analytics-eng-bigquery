{{ config(enabled=false) }} 

select * from {{ ref("stg_customers") }}
