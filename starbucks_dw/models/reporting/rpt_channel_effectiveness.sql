SELECT
  trs.promo_channel,
  trs.promo_type,
  cst.transaction_status,
  COUNT(DISTINCT cst.customer_id) AS total_response
FROM {{ ref("fct_promos_transactions") }} trs
INNER JOIN {{ ref("fct_customers_transactions") }} cst ON cst.transaction_id = trs.transaction_id
GROUP BY trs.promo_channel, trs.promo_type, cst.transaction_status
ORDER BY trs.promo_channel
