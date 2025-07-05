WITH base_transactions AS (
    SELECT
        fctct.transaction_id,
        fctct.customer_id,
        fctct.promo_id,
        fctct.transaction_status,
        dc.gender,
        -- Age group
        CASE 
            WHEN dc.age < 25 THEN 'Under 25'
            WHEN dc.age BETWEEN 25 AND 34 THEN '25-34'
            WHEN dc.age BETWEEN 35 AND 44 THEN '35-44'
            WHEN dc.age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+' 
        END AS age_group,
        -- Income group
        CASE 
            WHEN dc.income < 30000 THEN 'Low'
            WHEN dc.income BETWEEN 30000 AND 60000 THEN 'Medium'
            ELSE 'High'
        END AS income_group,
        -- Tenure group
        CASE
            WHEN DATE_DIFF(CURRENT_DATE(), dc.subscribed_date, MONTH) < 6 THEN 'New (<6m)'
            WHEN DATE_DIFF(CURRENT_DATE(), dc.subscribed_date, MONTH) BETWEEN 6 AND 24 THEN 'Mid (6m-2y)'
            ELSE 'Loyal (>2y)'
        END AS customer_tenure_group,
        dc.subscribed_date,
        fctct.ingested_at
    FROM {{ ref('fct_customers_transactions') }} fctct
    JOIN {{ ref('dim_customer') }} dc
        ON fctct.customer_id = dc.customer_id
),

with_engagement_and_response AS (
    SELECT
        bt.*,
        COUNT(*) OVER (PARTITION BY customer_id) AS total_promos_sent_per_customer,
        COUNTIF(transaction_status = 'completed') OVER (PARTITION BY customer_id) AS total_completed_per_customer
    FROM base_transactions bt
),

with_segments AS (
    SELECT
        *,
        -- Engagement segment
        CASE
            WHEN total_promos_sent_per_customer <= 2 THEN 'Low Engagement'
            WHEN total_promos_sent_per_customer BETWEEN 3 AND 5 THEN 'Moderate Engagement'
            ELSE 'High Engagement'
        END AS engagement_segment,

        -- Response segment
        CASE
            WHEN total_completed_per_customer = 0 THEN 'Non-responder'
            WHEN total_completed_per_customer <= 2 THEN 'Occasional responder'
            ELSE 'Frequent responder'
        END AS response_segment
    FROM with_engagement_and_response
),

promo_info AS (
    SELECT
        transaction_id,
        promo_type,
        promo_channel,
        transaction_status
    FROM {{ ref('fct_promos_transactions') }}
)

SELECT
    ws.gender,
    ws.age_group,
    ws.income_group,
    ws.customer_tenure_group,
    ws.engagement_segment,
    ws.response_segment,
    pi.promo_type,
    pi.promo_channel,
    COUNT(*) AS total_promos_sent,
    SUM(CASE WHEN pi.transaction_status = 'completed' THEN 1 ELSE 0 END) AS total_promos_completed,
    {{ calculate_completion_rate(
    'SUM(CASE WHEN pi.transaction_status = \'completed\' THEN 1 ELSE 0 END)',
    'COUNT(*)'
    ) }} AS completion_rate,
    CURRENT_DATE() AS report_date,
    CURRENT_TIMESTAMP() AS report_generated_at
FROM with_segments ws
JOIN promo_info pi
    ON ws.transaction_id = pi.transaction_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
ORDER BY 1, 2, 3, 4, 5, 6, 7, 8
