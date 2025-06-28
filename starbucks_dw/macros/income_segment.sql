{% macro income_segment(income_col) %}
CASE
    WHEN {{ income_col }} < 40000 THEN 'low'
    WHEN {{ income_col }} BETWEEN 40000 AND 70000 THEN 'medium'
    ELSE 'high'
END
{% endmacro %}
