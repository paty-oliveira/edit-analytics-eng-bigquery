{{ config(
    materialized = 'table',
    tags = ['reporting', 'promo', 'customer']
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
    cd.customer_id,
    cd.income,
    cd.age,
    cd.gender,

    COUNT(DISTINCT CASE WHEN t.promo_id IS NOT NULL THEN t.transaction_id END) AS promo_trans_count,
    COUNT(DISTINCT t.transaction_id) AS total_trans_count,

    SAFE_DIVIDE(
        COUNT(DISTINCT CASE WHEN t.promo_id IS NOT NULL THEN t.transaction_id END),
        COUNT(DISTINCT t.transaction_id)
    ) AS pct_promo_response

FROM transactions t
JOIN customer_dim cd
    ON t.customer_id = cd.customer_id

GROUP BY cd.customer_id, cd.income, cd.age, cd.gender
