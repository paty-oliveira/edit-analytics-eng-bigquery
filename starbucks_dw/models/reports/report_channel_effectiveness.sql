WITH base_metrics AS (
  SELECT
    promo_channel,
    promo_type,
    
    -- Transaction volume metrics
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT promo_id) AS unique_promos_offered,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    
    -- Status conversion metrics
    COUNTIF(transaction_status = 'received') AS received_count,
    COUNTIF(transaction_status = 'viewed') AS viewed_count,
    COUNTIF(transaction_status = 'completed') AS completed_count,
    COUNTIF(transaction_status = 'transaction') AS transaction_count,
    
    -- Reward and difficulty analysis
    AVG(promo_reward) AS avg_reward_offered,
    SUM(promo_reward) AS total_rewards_offered,
    AVG(promo_difficulty_rank) AS avg_difficulty_rank,
    
    -- Timing metrics
    AVG(promo_duration) AS avg_promo_duration_minutes,
    AVG(hours_since_start) AS avg_hours_to_action,
    AVG(days_since_start) AS avg_days_to_action,
    
    -- Rewards per successful transaction
    SAFE_DIVIDE(
      SUM(promo_reward), 
      COUNTIF(transaction_status = 'transaction')
    ) AS reward_per_transaction

  FROM {{ ref('fct_promos_transactions') }}
  GROUP BY promo_channel, promo_type
),

conversion_rates AS (
  SELECT
    *,
    -- Funnel effectiveness
    SAFE_DIVIDE(
      (viewed_count + completed_count + transaction_count) * 100.0, 
      received_count
    ) AS engagement_rate

  FROM base_metrics
),

channel_rankings AS (
  SELECT
    *,
    
    -- Rank channels by key metrics    
    ROW_NUMBER() OVER (
      PARTITION BY promo_type 
      ORDER BY transaction_count DESC
    ) AS volume_rank,
    
    ROW_NUMBER() OVER (
      PARTITION BY promo_type 
      ORDER BY reward_per_transaction ASC
    ) AS efficiency_rank,
    
    ROW_NUMBER() OVER (
      PARTITION BY promo_type 
      ORDER BY avg_hours_to_action ASC
    ) AS speed_rank

  FROM conversion_rates
),

final AS (
  SELECT
    promo_channel,
    promo_type,
    
    -- Volume metrics
    total_transactions,
    unique_promos_offered,
    unique_transactions,
    
    -- Funnel metrics
    received_count,
    viewed_count,
    completed_count,
    transaction_count,
    
    -- Conversion rates (rounded for readability)
    ROUND(COALESCE(engagement_rate, 0), 2) AS engagement_rate,
    
    -- Reward and timing metrics
    ROUND(avg_reward_offered, 2) AS avg_reward_offered,
    total_rewards_offered,
    ROUND(avg_difficulty_rank, 1) AS avg_difficulty_rank,
    ROUND(avg_promo_duration_minutes, 1) AS avg_promo_duration_minutes,
    ROUND(avg_hours_to_action, 1) AS avg_hours_to_action,
    ROUND(avg_days_to_action, 1) AS avg_days_to_action,
    ROUND(COALESCE(reward_per_transaction, 0), 2) AS reward_per_transaction,
    
    -- Rankings
    volume_rank,
    efficiency_rank,
    speed_rank,

  FROM channel_rankings
)

SELECT * 
FROM final
