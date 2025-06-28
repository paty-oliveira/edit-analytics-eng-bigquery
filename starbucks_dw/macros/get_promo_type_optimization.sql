{% macro promo_type_optimization(promo_type, view_rate, column_name) %}
    case
        when {{ promo_type }} = 'bogo' and {{ view_rate }} >= 30 then 'BOGO Optimized'
        when {{ promo_type }} = 'discount' and {{ view_rate }} >= 35 then 'Discount Optimized'
        when {{ promo_type }} = 'informational' and {{ view_rate }} >= 50 then 'Info Optimized'
        else 'Standard'
    end as {{ column_name }}
{% endmacro %}
