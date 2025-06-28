{{ config(materialized='table') }}

WITH transactions AS (
    SELECT
        customer_id,
        transaction_id,
        promo_id
    FROM {{ ref('fct_customers_transactions') }}
),

customer_dim AS (
    SELECT
        customer_id,
        income,
        age,
        gender,
        subscribed_date
    FROM {{ ref('dim_customer') }}
),

calc_response AS (
    SELECT
        dc.customer_id,
        dc.income,
        dc.age,
        dc.gender,
        dc.subscribed_date,
        DATE_DIFF(CURRENT_DATE(), dc.subscribed_date, DAY) AS days_since_subscription,

        {{ customer_response_base('t') }}

    FROM customer_dim dc
    LEFT JOIN transactions t ON dc.customer_id = t.customer_id
    GROUP BY
        dc.customer_id,
        dc.income,
        dc.age,
        dc.gender,
        dc.subscribed_date
)

SELECT
    customer_id,
    income,
    age,
    gender,
    subscribed_date,
    days_since_subscription,
    promo_trans_count,
    total_trans_count,
    pct_promo_response,

    {{ age_section('age') }} AS age_section,
    {{ income_segment('income') }} AS income_segment,
    {{ responsiveness_segment('pct_promo_response') }} AS responsiveness_segment

FROM calc_response
