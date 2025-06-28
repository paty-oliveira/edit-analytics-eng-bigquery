{% macro responsiveness_segment(pct_response_col) %}
CASE
    WHEN {{ pct_response_col }} < 0.3 THEN 'low'
    WHEN {{ pct_response_col }} BETWEEN 0.3 AND 0.7 THEN 'medium'
    ELSE 'high'
END
{% endmacro %}
