with customer_behavior as (
    select
        customer_id,
        countif(promo_id is null) as cnt_no_promo,
        countif(promo_id is not null) as cnt_with_promo
    from {{ ref('fct_customers_transactions') }}
    group by customer_id
)
, customer_segment as (
    select
        customer_id,
        case
            when cnt_no_promo > 0 and cnt_with_promo = 0 then 'No-promo-only'
            when cnt_with_promo > 0 and cnt_no_promo = 0 then 'Promo-only'
            when cnt_no_promo > 0 and cnt_with_promo > 0 then 'Mixed'
            else 'Undefined'
        end as promo_behavior_segment
    from customer_behavior
)
, info_customer as (
    select
        fct.customer_id,
        fct.age,
        fct.gender,
        fct.income,
        fct.transaction_status,
        fct.customer_subscribed_date,
        {{ age_group('age','age_group') }},
        {{ income_group('income','income_group') }},
        {{ subscription_years_group('customer_subscribed_date','customer_subscription_years_group') }},
        {{ get_date_parts('customer_subscribed_date', 'subscribed') }},
        cs.promo_behavior_segment
    from {{ ref('fct_customers_transactions') }} fct
    left join customer_segment cs on fct.customer_id = cs.customer_id
)
, transaction_agg as (
    select
        customer_id,
        {{ countif_status('transaction_status', 'received', 'promos_received') }},
        {{ countif_status('transaction_status', 'viewed', 'promos_viewed') }},
        {{ countif_status('transaction_status', 'completed', 'promos_completed') }},
        {{ countif_status('transaction_status', 'transaction', 'promos_transaction') }},
    from info_customer
    group by customer_id
)
, final as (
    select
        gender,
        age,
        age_group,
        income,
        income_group,
        promo_behavior_segment,
        promos_received,
        promos_viewed,
        promos_completed,
        promos_transaction,
        {{ response_rate('promos_viewed', 'promos_received', 'view_rate') }},
        customer_subscribed_date,
        customer_subscription_years_group,
        subscribed_year,
        subscribed_month,
        subscribed_day,
        subscribed_dayofweek,
        current_timestamp() as ingested_at
    from info_customer ic
        left join transaction_agg ta on ic.customer_id = ta.customer_id
    group by gender,
             age_group,
             age,
             income,
             income_group,
             customer_subscribed_date,
             customer_subscription_years_group,
             subscribed_year,
             subscribed_month,
             subscribed_day,
             subscribed_dayofweek,
             promo_behavior_segment,
             promos_received,
             promos_viewed,
             promos_completed,
             promos_transaction
)
select * from final
