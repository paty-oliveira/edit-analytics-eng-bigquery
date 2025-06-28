{% macro response_rate(responses, total, column_name) %}
    case
        when {{ total }} > 0 then round({{ responses }} * 100.0 / {{ total }}, 2)
        else 0
    end as {{ column_name }}
{% endmacro %}
