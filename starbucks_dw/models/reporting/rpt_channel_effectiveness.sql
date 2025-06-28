SELECT
  p.channel,
  COUNT(*) AS total_offers_sent,
  COUNT(DISTINCT pt.transaction_id) AS total_responses,
  {{ calc_response_rate("COUNT(DISTINCT pt.transaction_id)", "COUNT(*)") }} AS response_rate
FROM {{ ref('dim_promo') }} p
JOIN {{ ref('fct_promos_transactions') }} pt
  ON pt.promo_id = p.promo_id
GROUP BY 1
