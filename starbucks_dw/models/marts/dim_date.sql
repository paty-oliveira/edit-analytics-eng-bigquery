{{ config(enabled=false) }}

WITH base AS (
    {{ dbt_date.get_date_dimension("2025-01-01", "2100-12-31") }}
)
SELECT
    *,
    CURRENT_TIMESTAMP() AS ingested_at
FROM base
