with info_promo_transaction as (
    select
      promo_id,
      promo_channel,
      promo_type,
      promo_difficulty_rank,
      promo_duration,
      promo_reward,
      transaction_status,
      hours_since_start,
      days_since_start
    from {{ ref('fct_promos_transactions') }}
)
, info_agg as (
    select
      promo_id,
      {{ countif_status('transaction_status', 'received', 'promos_received') }},
      {{ countif_status('transaction_status', 'viewed', 'promos_viewed') }}
    from info_promo_transaction
    group by promo_id
)
, final as (
    select
      promo_channel,
      promo_type,
      promo_difficulty_rank,
      promo_duration,
      promo_reward,
      promos_received,
      promos_viewed,
      hours_since_start,
      days_since_start,
      {{ response_rate('promos_viewed', 'promos_received', 'view_rate') }},
      current_timestamp() as ingested_at
    from info_promo_transaction ipt
        left join info_agg ia on ipt.promo_id = ia.promo_id
    group by
        promo_channel,
        promo_type,
        promo_difficulty_rank,
        promo_duration,
        promo_reward,
        promos_received,
        promos_viewed,
        hours_since_start,
        days_since_start
)
select * from final
