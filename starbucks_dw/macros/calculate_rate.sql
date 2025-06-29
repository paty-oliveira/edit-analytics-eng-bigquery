{% macro calculate_rate(numerator, denominator, decimals=2) %}
    case
        when {{ denominator }} = 0 then null
        else round(({{ numerator }} * 100.0) / {{ denominator }}, {{ decimals }})
    end
{% endmacro %}
