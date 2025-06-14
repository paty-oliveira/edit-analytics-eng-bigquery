{% set surrogate_key_columns = [
    "transactions.promo_id",
    "transactions.transaction_id",
    "promos.channel",
] %}

with
    promos as (
        select promo_id, promo_type, channel, difficulty_rank, duration
        from {{ ref("dim_promo") }}
    ),

    transactions as (
        select
            transaction_id,
            promo_id,
            transaction_type,
            reward,
            hours_since_start,
            days_since_start
        from {{ ref("stg_transactions") }}
    ),

    final as (
        select
            {{ dbt_utils.generate_surrogate_key(surrogate_key_columns) }}
            as promo_transaction_key,
            transactions.promo_id,
            transactions.transaction_id,
            promos.promo_type,
            promos.channel as promo_channel,
            promos.difficulty_rank as promo_difficulty_rank,
            promos.duration as promo_duration,
            transactions.reward as promo_reward,
            {{ format_transaction_type ('transactions.transaction_type') }} as transaction_status,
            transactions.hours_since_start,
            transactions.days_since_start,
            current_timestamp as ingested_at
        from transactions
        inner join promos on transactions.promo_id = promos.promo_id
    )

select *
from final
