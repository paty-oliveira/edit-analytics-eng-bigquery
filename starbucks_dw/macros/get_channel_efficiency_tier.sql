{% macro channel_efficiency_tier(view_rate, column_name) %}
    case
        when {{ view_rate }} >= 80 then 'Highly Efficient'
        when {{ view_rate }} >= 60 then 'Moderately Efficient'
        when {{ view_rate }} >= 40 then 'Low Efficiency'
        else 'Inefficient'
    end as {{ column_name }}
{% endmacro %}
