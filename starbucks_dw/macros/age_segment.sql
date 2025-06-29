{% macro age_segment(age_col) %}
CASE
    WHEN {{ age_col }} IS NULL THEN 'unknown'
    WHEN {{ age_col }} < 18 THEN '<18'
    WHEN {{ age_col }} BETWEEN 18 AND 24 THEN '18-24'
    WHEN {{ age_col }} BETWEEN 25 AND 34 THEN '25-34'
    WHEN {{ age_col }} BETWEEN 35 AND 44 THEN '35-44'
    WHEN {{ age_col }} BETWEEN 45 AND 54 THEN '45-54'
    WHEN {{ age_col }} BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+'
END
{% endmacro %}
