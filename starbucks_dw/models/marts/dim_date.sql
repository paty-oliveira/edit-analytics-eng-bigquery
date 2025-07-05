{{ config(materialized = "table") }}

{{ dbt_date.get_date_dimension("2020-01-01", "2100-12-30") }}

--select 1
--union all
--select 2
