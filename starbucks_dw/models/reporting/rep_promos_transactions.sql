WITH transaction_status as (
    SELECT
        promo_channel, promo_type,
        sum(case when transaction_status = 'received' then 1 else 0 end) as total_promos_received,
        sum(case when transaction_status = 'viewed' then 1 else 0 end) as total_promos_viewed
    FROM {{ ref("fct_promos_transactions") }}
    GROUP BY 1, 2
)

SELECT fpt.promo_channel, fpt.promo_type,
sum(promo_difficulty_rank) as promo_difficulty_rank, sum(promo_duration) as promo_duration,
sum(promo_reward) as promo_reward, sum(hours_since_start) as hours_since_start,
sum(days_since_start) as days_since_start,
total_promos_received,
total_promos_viewed,
{{calculate_rate('total_promos_viewed','total_promos_received') }} as response_rate
--round((total_promos_viewed/total_promos_received)*100,2) as response_rate
FROM {{ ref("fct_promos_transactions") }} fpt
LEFT JOIN transaction_status ts ON ts.promo_channel = fpt.promo_channel AND ts.promo_type = fpt.promo_type
GROUP BY promo_channel, promo_type, total_promos_received, total_promos_viewed
