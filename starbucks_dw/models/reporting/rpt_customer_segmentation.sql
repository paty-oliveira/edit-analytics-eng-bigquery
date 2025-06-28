SELECT
  c.customer_id,
  c.gender,
  {{ age_group_case('c.age', [(18, 24, '18-24'), (25, 34, '25-34'), (35, 44, '35-44'), (45, 54, '45-54'), (55, 200, '55+')]) }} AS age_group,
  COUNT(DISTINCT t.transaction_id) AS total_transactions,
  COUNT(DISTINCT pt.transaction_id) AS promo_responses,
  {{ calc_response_rate("COUNT(DISTINCT pt.transaction_id)", "COUNT(DISTINCT t.transaction_id)") }} AS response_rate
FROM {{ ref('dim_customer') }} c
LEFT JOIN {{ ref('fct_customers_transactions') }} t ON t.customer_id = c.customer_id
LEFT JOIN {{ ref('fct_promos_transactions') }} pt ON pt.transaction_id = t.transaction_id
GROUP BY 1, 2, 3
