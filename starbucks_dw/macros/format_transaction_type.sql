{% macro format_transaction_type(transaction_type, column_name) %}
    case
        when {{ transaction_type }} = 'offer received' then 'received'
        when {{ transaction_type }} = 'offer viewed' then 'viewed'
        when {{ transaction_type }} = 'offer completed' then 'completed'
        when {{ transaction_type }} = 'transaction' then 'transaction'
    end as {{ column_name }}
{% endmacro %}
