with base as (
    {{ dbt_date.get_date_dimension("2025-01-01", "2100-12-31") }}
)

select
    *,
    current_timestamp as ingested_at
from base
