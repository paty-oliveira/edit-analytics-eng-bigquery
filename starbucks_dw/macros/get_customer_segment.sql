{% macro customer_segment(organic_events, promo_events, column_name) %}
    case
        when {{ organic_events }} > 0 and {{ promo_events }} = 0 then 'Organic Driven'
        when {{ promo_events }} > 0 and {{ organic_events }} = 0 then 'Promo Driven'
        when {{ organic_events }} > 0 and {{ promo_events }} > 0 then 'Mixed'
        else 'Inactive'
    end as {{ column_name }}
{% endmacro %}
