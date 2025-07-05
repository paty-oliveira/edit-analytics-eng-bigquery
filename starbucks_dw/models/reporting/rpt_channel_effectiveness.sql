WITH base AS (
    SELECT
        fpt.transaction_id,
        fpt.promo_type,
        fpt.promo_channel,
        fpt.transaction_status,
        fpt.days_since_start,
        fpt.promo_reward,
        fpt.promo_difficulty_rank
    FROM {{ ref('fct_promos_transactions') }} fpt
),

metrics AS (
    SELECT
        promo_channel,
        promo_type,

        -- Promo counts
        COUNT(*) AS total_promos_sent,
        SUM(CASE WHEN transaction_status = 'completed' THEN 1 ELSE 0 END) AS total_promos_completed,

        -- Performance metrics
        AVG(CASE WHEN transaction_status = 'completed' THEN days_since_start END) AS avg_days_to_completion,
        AVG(promo_reward) AS avg_reward,
        AVG(promo_difficulty_rank) AS avg_difficulty,

        -- Completion rate
        SAFE_DIVIDE(SUM(CASE WHEN transaction_status = 'completed' THEN 1 ELSE 0 END), COUNT(*)) AS completion_rate,

        -- Audit columns
        CURRENT_DATE() AS report_date,
        CURRENT_TIMESTAMP() AS report_generated_at

    FROM base
    GROUP BY 1, 2
)

SELECT * FROM metrics
ORDER BY promo_channel, promo_type
LIMIT 1000