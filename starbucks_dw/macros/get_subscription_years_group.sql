{% macro subscription_years_group(customer_subscribed_date, column_name) %}
    case
        when date_diff(current_date, {{ customer_subscribed_date }}, year) < 5 then '0-4'
        when date_diff(current_date, {{ customer_subscribed_date }}, year) < 7 then '5-6'
        when date_diff(current_date, {{ customer_subscribed_date }}, year) < 9 then '7-8'
        when date_diff(current_date, {{ customer_subscribed_date }}, year) < 11 then '9-10'
        when date_diff(current_date, {{ customer_subscribed_date }}, year) < 13 then '11-12'
        else '13+'
    end as {{ column_name }}
{% endmacro %}
