SELECT
  cst.customer_id,
  cst.gender,
  cst.age,
  cst.income,
  trs.transaction_status,
  SUM(trs.promo_reward) AS total_promo_reward
FROM {{ ref("fct_customers_transactions") }} cst
INNER JOIN {{ ref("fct_promos_transactions") }} trs ON cst.transaction_id = trs.transaction_id
GROUP BY cst.customer_id, cst.gender, cst.age, cst.income, trs.transaction_status
