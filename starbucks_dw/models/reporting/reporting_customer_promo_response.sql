with customer_base as (
  select
    customer_id,
    gender,
    age,
    income,
    subscribed_date,
    {{ age_segment('age') }} as age_segment,
    {{ income_segment('income') }} as income_segment,
    date_diff(current_date(), subscribed_date, day) as days_since_subscription,
    {{ subscription_age_segment('date_diff(current_date(), subscribed_date, day)') }} as subscription_age_segment
  from {{ ref('dim_customer') }}
),

customer_transaction_metrics as (
  select
    customer_id,
    {{ count_distinct_cond("transaction_status = 'received'") }} as total_offers_received,
    {{ count_distinct_cond("transaction_status = 'viewed'") }} as total_offers_viewed,
    {{ count_distinct_cond("transaction_status = 'completed'") }} as total_offers_completed,
    {{ count_distinct_cond("transaction_status = 'transaction'") }} as total_transactions,
    count(distinct promo_id) as unique_promos_engaged,

    {{ ratio("transaction_status = 'viewed'", "transaction_status = 'received'", "view_rate") }},
    {{ ratio("transaction_status = 'completed'", "transaction_status = 'received'", "completion_rate") }},
    {{ ratio("transaction_status = 'transaction'", "transaction_status = 'completed'", "conversion_rate") }},

    max(case when transaction_status in ('viewed', 'completed', 'transaction') then ingested_at end) as last_engagement_date,
    date_diff(current_date(), max(case when transaction_status in ('viewed', 'completed', 'transaction') then date(ingested_at) end), day) as days_since_last_activity
  from {{ ref('fct_customers_transactions') }}
  group by customer_id
),

behavioral_segments as (
  select
    customer_id,
    total_offers_received,
    total_offers_viewed,
    total_offers_completed,
    total_transactions,
    unique_promos_engaged,
    view_rate,
    completion_rate,
    conversion_rate,
    last_engagement_date,
    days_since_last_activity,

    {{ engagement_segment('completion_rate', 'total_offers_received') }} as engagement_segment,
    {{ responsiveness_segment('view_rate') }} as responsiveness_segment

  from customer_transaction_metrics
)

select
  cb.customer_id,
  cb.gender,
  cb.age,
  cb.income,
  cb.subscribed_date,
  cb.days_since_subscription,
  cb.age_segment,
  cb.income_segment,
  cb.subscription_age_segment,

  coalesce(bs.total_offers_received, 0) as total_offers_received,
  coalesce(bs.total_offers_viewed, 0) as total_offers_viewed,
  coalesce(bs.total_offers_completed, 0) as total_offers_completed,
  coalesce(bs.total_transactions, 0) as total_transactions,
  coalesce(bs.unique_promos_engaged, 0) as unique_promos_engaged,

  round(coalesce(bs.view_rate, 0), 2) as view_rate,
  round(coalesce(bs.completion_rate, 0), 2) as completion_rate,
  round(coalesce(bs.conversion_rate, 0), 2) as conversion_rate,

  bs.last_engagement_date,
  coalesce(bs.days_since_last_activity, 9999) as days_since_last_activity,

  coalesce(bs.engagement_segment, 'No Engagement') as engagement_segment,
  coalesce(bs.responsiveness_segment, 'Unresponsive') as responsiveness_segment

from customer_base cb
left join behavioral_segments bs on cb.customer_id = bs.customer_id
