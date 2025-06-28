{% macro promo_responsiveness_segment(promos_received, completion_received_rate, column_name) %}
    case
        when {{ promos_received }} > 0 and {{ completion_received_rate }} >= 70 then 'Highly Responsive'
        when {{ promos_received }} > 0 and {{ completion_received_rate }} >= 40 then 'Moderately Responsive'
        when {{ promos_received }} > 0 and {{ completion_received_rate }} >= 10 then 'Low Responsive'
        when {{ promos_received }} > 0 then 'Non-Responsive'
        else 'No Promos Received'
    end as {{ column_name }}
{% endmacro %}
