with info_promo as (
    select
      promo_id,
      channel,
      promo_type,
      difficulty_rank,
      duration,
      reward
    from {{ ref('dim_promo') }}
)
, info_promo_transaction as (
    select
      ip.promo_id,
      promo_channel,
      ip.promo_type,
      promo_difficulty_rank,
      promo_duration,
      promo_reward,
      transaction_status,
      hours_since_start,
      days_since_start
    from info_promo ip
      inner join {{ ref('fct_promos_transactions') }} fpt on ip.promo_id = fpt.promo_id
)
, promo_behaviour as (
    select
      promo_id,
      count(*) as total_events,
      count(distinct promo_id) as unique_promos,
      {{ countif_status('transaction_status', 'received', 'promos_received') }},
      {{ countif_status('transaction_status', 'viewed', 'promos_viewed') }}
    from info_promo_transaction
    group by promo_id
)
, promo_rate as (
    select
      promo_id,
      {{ response_rate('promos_viewed', 'promos_received', 'view_rate') }}
    from promo_behaviour
)
, promo_aggregations as (
    select
      ipt.promo_id,
      promo_channel,
      promo_type,
      promo_difficulty_rank,
      promo_duration,
      promo_reward,
      total_events,
      unique_promos,
      promos_received,
      promos_viewed,
      view_rate,
      {{ avg_metric('promo_difficulty_rank', 'avg_difficulty_rank') }},
      {{ avg_metric('promo_duration', 'avg_duration') }},
      {{ avg_metric('promo_reward', 'avg_reward') }},
      {{ avg_metric('hours_since_start', 'avg_hours_since_start') }},
      {{ avg_metric('days_since_start', 'avg_days_since_start') }},
    from info_promo_transaction ipt
      left join promo_behaviour ia on ipt.promo_id = ia.promo_id
      left join promo_rate pr on ipt.promo_id = pr.promo_id
    group by
        ipt.promo_id,
        promo_channel,
        promo_type,
        promo_difficulty_rank,
        promo_duration,
        promo_reward,
        total_events,
        unique_promos,
        promos_received,
        promos_viewed,
        view_rate
)
, final as (
    select
      promo_channel,
      promo_type,
      promo_difficulty_rank,
      promo_duration,
      promo_reward,
      total_events,
      unique_promos,
      promos_received,
      promos_viewed,
      view_rate,
      avg_difficulty_rank,
      avg_duration,
      avg_reward,
      avg_hours_since_start,
      avg_days_since_start,
      {{ channel_efficiency_tier('view_rate','channel_efficiency_tier') }},
      {{ promo_type_optimization('promo_type','view_rate','promo_type_optimization') }},
      current_timestamp() as ingested_at
    from promo_aggregations pa
)
select * from final
