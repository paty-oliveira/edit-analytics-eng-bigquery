{{ config(
    materialized = 'table'
) }}

with promo_engagement as (
  select
    pt.transaction_id,
    pt.transaction_status,
    p.channel,
    p.promo_type
  from {{ ref('fct_promos_transactions') }} pt
  join {{ ref('dim_promo') }} p on pt.promo_id = p.promo_id
),

engagement_agg as (
  select
    channel,
    promo_type,
    {{ promo_metrics('pt') }}
  from promo_engagement pt
  group by channel, promo_type
),

customer_response as (
  select
    pt.customer_id,
    pt.promo_id,
    p.channel,
    p.promo_type,
    p.difficulty_rank,
    p.reward
  from {{ ref('fct_customers_transactions') }} pt
  join {{ ref('dim_promo') }} p
    on pt.promo_id = p.promo_id
),

response_agg as (
  select
    channel,
    promo_type,
    count(distinct customer_id) as customers_responded,
    count(distinct promo_id) as total_promos,
    avg(difficulty_rank) as avg_difficulty_rank,
    avg(reward) as avg_reward
  from customer_response
  group by channel, promo_type
)

select
  e.channel,
  e.promo_type,
  e.promos_received,
  e.promos_viewed,
  e.total_transactions,
  e.view_rate,
  r.customers_responded,
  r.total_promos,
  r.avg_difficulty_rank,
  r.avg_reward
from engagement_agg e
left join response_agg r
  on e.channel = r.channel
 and e.promo_type = r.promo_type
order by e.view_rate desc, e.promos_received desc
