{% macro calc_response_rate(numerator, denominator) %}
  SAFE_DIVIDE({{ numerator }}, {{ denominator }})
{% endmacro %}
