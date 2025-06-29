with customer_transaction_status as (
    select
        customer_id,
        sum(case when transaction_status = 'received' then 1 else 0 end) as total_offers_received,
        sum(case when transaction_status = 'viewed' then 1 else 0 end) as total_offers_viewed,
        sum(case when transaction_status = 'completed' then 1 else 0 end) as total_offers_completed,
        sum(case when transaction_status = 'transaction' then 1 else 0 end) as total_transactions
    from {{ ref("fct_customers_transactions") }}
    group by 1
)


select fct.customer_id, gender, age, income, customer_subscribed_date,
case when age between 18 and 28 then 'Gen Z'
     when age between 29 and 44 then 'Gen Y'
     when age between 45 and 60 then 'Gen X'
     when age between 61 and 79 then 'Boomers'
     when age > 79 then 'Seniors'
end as age_segment,

case
  when date_diff(current_date(), customer_subscribed_date, year) < 1 then 'Newcomer'
  when date_diff(current_date(), customer_subscribed_date, year) between 1 and 2 then 'Engaged'
  when date_diff(current_date(), customer_subscribed_date, year) between 3 and 4 then 'Loyal'
  when date_diff(current_date(), customer_subscribed_date, year) between 5 and 6 then 'Veteran'
  when date_diff(current_date(), customer_subscribed_date, year) >= 7 then 'Legacy Member'
end as subscription_segment,
case when income < 30 then 'Basic'
     when income between 30 and 49 then 'Silver'
     when income between 50 and 79 then 'Gold'
     when income >= 80 then 'Platinum'
end as income_segment,
cts.total_offers_received,
cts.total_offers_viewed,
cts.total_offers_completed,
cts.total_transactions,
{{calculate_rate('total_offers_completed','total_offers_received') }} as response_rate
FROM {{ ref("fct_customers_transactions") }} fct
inner JOIN customer_transaction_status cts on cts.customer_id = fct.customer_id
group by fct.customer_id, gender, age, income, customer_subscribed_date, cts.total_offers_received, cts.total_offers_viewed, cts.total_offers_completed, cts.total_transactions
