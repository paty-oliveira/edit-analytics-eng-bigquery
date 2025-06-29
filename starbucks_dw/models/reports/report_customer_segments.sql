WITH customer_base AS (
  SELECT
    customer_id,
    gender,
    age,
    income,
    subscribed_date,
    {{ segment_by_interval('age', [25, 40, 56], ['Gen Z', 'Millennial', 'Gen X', 'Boomer']) }} AS age_segment,    
    {{ segment_by_interval('income', [50000, 100000], ['Low Income', 'Middle Income', 'High Income'], 'Unknown Income') }} AS income_segment,
    date_diff(current_date(), subscribed_date, DAY) AS days_since_subscription,
  FROM {{ ref('dim_customer') }}
),

customer_transaction_metrics AS (
  SELECT 
    customer_id,
    count(DISTINCT case WHEN transaction_status = 'received' THEN transaction_id END) AS total_offers_received,
    count(DISTINCT case WHEN transaction_status = 'viewed' THEN transaction_id END) AS total_offers_viewed,
    count(DISTINCT case WHEN transaction_status = 'completed' THEN transaction_id END) AS total_offers_completed,
    count(DISTINCT case WHEN transaction_status = 'transaction' THEN transaction_id END) AS total_transactions,
    count(DISTINCT promo_id) AS unique_promos_engaged,
    
    -- Response rates
    {{ calculate_transaction_status_rate('viewed', 'received', 'view_rate') }},
    {{ calculate_transaction_status_rate('received', 'completed', 'completion_rate') }}
    
  FROM {{ ref('fct_customers_transactions') }}
  GROUP BY customer_id
),

behavioral_segments AS (
  SELECT 
    *,
    -- Behavioral segmentation based on engagement patterns
    case 
      WHEN completion_rate >= 0.7 and total_offers_received >= 5 THEN 'High Performer'
      WHEN completion_rate >= 0.4 and total_offers_received >= 3 THEN 'Engaged'
      WHEN completion_rate >= 0.1 and total_offers_received >= 2 THEN 'Moderate'
      WHEN total_offers_received >= 1 and completion_rate < 0.1 THEN 'Low Engagement'
      ELSE 'No Engagement'
    END AS engagement_segment,
    
    -- Responsiveness segment
    case 
      WHEN view_rate >= 0.8 THEN 'Highly Responsive'
      WHEN view_rate >= 0.5 THEN 'Moderately Responsive'
      WHEN view_rate >= 0.2 THEN 'Selective'
      ELSE 'Unresponsive'
    END AS responsiveness_segment,
  FROM customer_transaction_metrics
),

final AS (
  SELECT 
    cb.customer_id,
    cb.gender,
    cb.age,
    cb.income,
    cb.subscribed_date,
    cb.days_since_subscription,
    
    -- Demographic segments
    cb.age_segment,
    cb.income_segment,
    
    -- Behavioral segments
    coalesce(bs.engagement_segment, 'No Engagement') AS engagement_segment,
    coalesce(bs.responsiveness_segment, 'Unresponsive') AS responsiveness_segment,
    
    
    -- Performance metrics
    coalesce(bs.total_offers_received, 0) AS total_offers_received,
    coalesce(bs.total_offers_viewed, 0) AS total_offers_viewed,
    coalesce(bs.total_offers_completed, 0) AS total_offers_completed,
    coalesce(bs.total_transactions, 0) AS total_transactions,
    coalesce(bs.unique_promos_engaged, 0) AS unique_promos_engaged,
    
    round(coalesce(bs.view_rate, 0), 4) AS view_rate,
    round(coalesce(bs.completion_rate, 0), 4) AS completion_rate,
    
    -- Customer tier
    case 
      WHEN coalesce(bs.completion_rate, 0) >= 0.5 and cb.income > 75000 THEN 'High Value'
      WHEN coalesce(bs.completion_rate, 0) >= 0.3 and coalesce(bs.view_rate, 0) >= 0.5 THEN 'Good Value'
      WHEN coalesce(bs.completion_rate, 0) >= 0.1 and coalesce(bs.view_rate, 0) >= 0.3 THEN 'Average Value'
      ELSE 'Low Value'
    END AS customer_tier,
    
    -- Flags for easy filtering
    case WHEN coalesce(bs.completion_rate, 0) >= 0.5 THEN true ELSE false END AS is_high_converter,
    case WHEN coalesce(bs.view_rate, 0) >= 0.7 THEN true ELSE false END AS is_highly_responsive,
    case WHEN cb.income > 75000 and coalesce(bs.completion_rate, 0) >= 0.3 THEN true ELSE false END AS is_high_value_prospect,
    
    current_timestamp() AS created_at
    
  FROM customer_base cb
  left join behavioral_segments bs on cb.customer_id = bs.customer_id
)

SELECT * FROM final
