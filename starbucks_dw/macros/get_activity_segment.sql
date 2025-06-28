{% macro activity_segment(promos_transaction, column_name) %}
    case
        when {{ promos_transaction }} = 0 then 'Never Purchased'
        when {{ promos_transaction }} >= 20 then 'High Activity'
        when {{ promos_transaction }} >= 10 then 'Medium Activity'
        when {{ promos_transaction }} >= 3 then 'Low Activity'
        else 'Minimal Activity'
    end as {{ column_name }}
{% endmacro %}
