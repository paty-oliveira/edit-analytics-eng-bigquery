{{ config(
    materialized = 'table'
) }}

WITH transactions AS (
    SELECT
        fct.customer_id,
        fct.transaction_id,
        fct.promo_id
    FROM {{ ref('fct_customers_transactions') }} fct
),

customer_dim AS (
    SELECT
        customer_id,
        income,
        age,
        gender
    FROM {{ ref('dim_customer') }}
)

SELECT
    dc.customer_id,
    dc.income,
    dc.age,
    dc.gender,
    {{ format_promo_metrics('fct') }}
FROM {{ ref('fct_customers_transactions') }} AS fct
JOIN {{ ref('dim_customer') }} AS dc
  ON fct.customer_id = dc.customer_id
GROUP BY dc.customer_id, dc.income, dc.age, dc.gender
