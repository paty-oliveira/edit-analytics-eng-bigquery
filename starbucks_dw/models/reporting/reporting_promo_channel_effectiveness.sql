{{ config(
    materialized = 'table'
) }}

WITH promo_transactions AS (
  SELECT
    pt.customer_id,
    pt.promo_id,
    p.channel,
    p.promo_type,
    p.difficulty_rank,
    p.reward
  FROM {{ ref('fct_customers_transactions') }} pt
  JOIN {{ ref('dim_promo') }} p
    ON pt.promo_id = p.promo_id
)

SELECT
  channel,
  promo_type,
  COUNT(DISTINCT customer_id) AS customers_responded,
  COUNT(DISTINCT promo_id) AS total_promos,
  AVG(difficulty_rank) AS avg_difficulty_rank,
  AVG(reward) AS avg_reward
FROM promo_transactions
GROUP BY channel, promo_type
ORDER BY customers_responded DESC
