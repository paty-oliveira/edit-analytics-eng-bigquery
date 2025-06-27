with info_customer as (
    select
        customer_id,
        age,
        gender,
        income,
        subscribed_date as customer_subscribed_date,
        {{ age_group('age','age_group') }},
        {{ income_group('income','income_group') }},
        {{ subscription_years_group('subscribed_date','customer_subscription_years_group') }},
        {{ get_date_parts('subscribed_date', 'subscribed') }}
        from {{ ref('dim_customer') }}
)
, customer_behavior as (
    select
        customer_id,
        count(*) as total_events,
        count(distinct transaction_id) as unique_transaction_sessions,
        countif(promo_id is null) as organic_events,
        countif(promo_id is not null) as promo_events,
        {{ countif_status('transaction_status', 'received', 'promos_received') }},
        {{ countif_status('transaction_status', 'viewed', 'promos_viewed') }},
        {{ countif_status('transaction_status', 'completed', 'promos_completed') }},
        {{ countif_status('transaction_status', 'transaction', 'promos_transaction') }},
    from {{ ref('fct_customers_transactions') }}
    group by customer_id
)
, enhanced_customer_segment as (
    select
        ic.customer_id,
        cb.total_events,
        cb.unique_transaction_sessions,
        cb.organic_events,
        cb.promo_events,
        cb.promos_received,
        cb.promos_viewed,
        cb.promos_completed,
        cb.promos_transaction,
        {{ customer_segment('organic_events', 'promo_events', 'promo_behavior_segment') }},
        {{ activity_segment('promos_transaction', 'activity_segment') }},
        {{ engagement_segment('unique_transaction_sessions', 'engagement_segment') }}
    from info_customer ic
        left join customer_behavior cb on ic.customer_id = cb.customer_id
)
, customer_rates as (
    select
        customer_id,
        {{ response_rate('promos_viewed', 'promos_received', 'view_rate') }},
        {{ response_rate('promos_completed', 'promos_received', 'completion_received_rate') }},
        {{ response_rate('promos_completed', 'promos_viewed', 'completion_viewed_rate') }},
        {{ response_rate('promos_completed', 'promos_transaction', 'conversion_rate') }},
        {{ response_rate('promo_events', 'total_events', 'promo_engagement_rate') }}
    from enhanced_customer_segment
)
, final as (
    select
        ic.customer_id,
        ic.gender,
        ic.age,
        ic.age_group,
        ic.income,
        ic.income_group,
        ic.customer_subscribed_date,
        ic.customer_subscription_years_group,
        ic.subscribed_year,
        ic.subscribed_month,
        ic.subscribed_day,
        ic.subscribed_dayofweek,
        ecs.total_events,
        ecs.unique_transaction_sessions,
        ecs.organic_events,
        ecs.promo_events,
        ecs.promos_received,
        ecs.promos_viewed,
        ecs.promos_completed,
        ecs.promos_transaction,
        ecs.promo_behavior_segment,
        ecs.activity_segment,
        ecs.engagement_segment,
        cr.view_rate,
        cr.completion_received_rate,
        cr.completion_viewed_rate,
        cr.conversion_rate,
        cr.promo_engagement_rate,
        {{ promo_responsiveness_segment('promos_received', 'completion_received_rate', 'promo_responsiveness_segment') }},
        current_timestamp() as ingested_at
    from info_customer ic
        left join enhanced_customer_segment ecs on ic.customer_id = ecs.customer_id
        left join customer_rates cr on ic.customer_id = cr.customer_id
)
select * from final
