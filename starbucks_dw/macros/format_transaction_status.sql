
{% macro format_transaction_statusold(transaction_type_column) %}
    CASE
        WHEN {{ transaction_type_column }} = 'offer received' THEN 'received'
        WHEN {{ transaction_type_column }} = 'offer viewed' THEN 'viewed'
        WHEN {{ transaction_type_column }} = 'offer completed' THEN 'completed'
        WHEN {{ transaction_type_column }} = 'transaction' THEN 'transaction'
        ELSE 'unknown'
    END
{% endmacro %}

{% macro format_transaction_status(transaction_type_column) %}
    {%- set mapping = {
        'offer received': 'received',
        'offer viewed': 'viewed',
        'offer completed': 'completed',
        'transaction': 'transaction'
    } %}

    CASE
        {%- for key, value in mapping.items() %}
            WHEN {{ transaction_type_column }} = '{{ key }}' THEN '{{ value }}'
        {%- endfor %}
        ELSE 'unknown'
    END
{% endmacro %}
