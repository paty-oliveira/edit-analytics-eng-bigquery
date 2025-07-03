{% macro income_group(income, column_name) %}
    case
        when {{ income }} < 30000 then '<30k'
        when {{ income }} < 45000 then '30-45k'
        when {{ income }} < 60000 then '45-60k'
        when {{ income }} < 75000 then '60-75k'
        when {{ income }} < 90000 then '75-90k'
        when {{ income }} < 105000 then '90-105k'
        else '> 105k'
    end as {{ column_name }}
{% endmacro %}
