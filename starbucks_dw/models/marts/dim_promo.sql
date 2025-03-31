{% set surrogate_key_columns = ["promo_id", "channel"] %}

with
    unnested_channels as (
        select
            promo_id,
            promo_type,
            difficulty_rank,
            reward,
            duration,
            ingested_at,
            cast(channel as string) as channel
        from {{ ref("stg_promos") }}, unnest(channels) as channel
    ),

    final as (
        select
            {{ dbt_utils.generate_surrogate_key(surrogate_key_columns) }}
            as promo_channel_key,
            promo_id,
            promo_type,
            channel,
            difficulty_rank,
            reward,
            duration,
            ingested_at
        from unnested_channels
    )

select *
from final
