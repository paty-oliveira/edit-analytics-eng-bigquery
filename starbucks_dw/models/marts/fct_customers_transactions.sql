
{% set surrogate_key_columns = [
    "transactions.transaction_id",
    "transactions.customer_id",
    "transactions.promo_id",
] %}

with
    customers as (
        select customer_id, gender, age, income, subscribed_date
        from {{ ref("stg_customers") }}
    ),

    transactions as (
        select transaction_id, customer_id, promo_id, transaction_type
        from {{ ref("stg_transactions") }}
    ),

    final as (
        select
            {{ dbt_utils.generate_surrogate_key(surrogate_key_columns) }}
            as customer_transaction_key,
            transactions.transaction_id,
            transactions.customer_id,
            transactions.promo_id,
            customers.gender,
            customers.age,
            customers.income,
            case
                when transactions.transaction_type = "offer received"
                then "received"
                when transactions.transaction_type = "offer viewed"
                then "viewed"
                when transactions.transaction_type = "offer completed"
                then "completed"
                when transactions.transaction_type = "transaction"
                then "transaction"
            end as transaction_status,
            customers.subscribed_date as customer_subscribed_date,
            current_timestamp as ingested_at
        from transactions
        inner join customers on transactions.customer_id = customers.customer_id
    )

select *
from final
