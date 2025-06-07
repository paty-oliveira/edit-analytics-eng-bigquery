{% macro format_transaction_type(transaction_type) %}
    case
        when {{ transactions.transaction_type }} = "offer received"
            then "received"
        when {{ transactions.transaction_type }} = "offer viewed"
            then "viewed"
        when {{ transactions.transaction_type }} = "offer completed"
            then "completed"
        when {{transactions.transaction_type}} = "transaction"
            then "transaction"
    end as transaction_status,
{% endmacro %}