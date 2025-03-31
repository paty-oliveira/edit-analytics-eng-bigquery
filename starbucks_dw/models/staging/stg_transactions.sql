{% set surrogate_key_columns = [
    "customer_id",
    "promo_id",
    "transaction_type",
    "hours_since_start",
] %}

with
    cleaned_transactions as (
        select
            person as customer_id,
            event as transaction_type,
            json_extract(value, "$") as transaction_value,
            time as hours_since_start,
            {{ get_days_from_hours("time") }} as days_since_start
        from {{ source("starbucks", "transactions") }}
    ),

    unnest_transactions as (
        select
            customer_id,
            transaction_type,
            hours_since_start,
            cast(days_since_start as integer) as days_since_start,
            cast(json_extract(transaction_value, "$.offer id") as string) as promo_id,
            json_extract(transaction_value, "$.reward") as reward,
            json_extract(transaction_value, "$.amount") as amount,
        from cleaned_transactions
    ),

    all_transactions as (
        select
            {{ dbt_utils.generate_surrogate_key(surrogate_key_columns) }}
            as transaction_id,
            customer_id,
            promo_id,
            transaction_type,
            hours_since_start,
            days_since_start,
            coalesce(cast(reward as integer), 0) as reward,
            coalesce(cast(amount as decimal), 0) as amount,
        from unnest_transactions
    ),

    deduplicated_transactions as (
        select *, row_number() over (partition by transaction_id) as row_number
        from all_transactions

    ),

    final as (
        select
            transaction_id,
            customer_id,
            promo_id,
            transaction_type,
            hours_since_start,
            days_since_start,
            reward,
            amount,
            current_timestamp as ingested_at,
        from deduplicated_transactions
        where row_number = 1
    )

select *
from final
