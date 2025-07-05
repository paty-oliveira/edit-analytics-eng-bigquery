{% macro calculate_completion_rate(numerator, denominator) %}
    SAFE_DIVIDE({{ numerator }}, {{ denominator }})
{% endmacro %}
-- This macro calculates the completion rate by safely dividing the numerator by the denominator.