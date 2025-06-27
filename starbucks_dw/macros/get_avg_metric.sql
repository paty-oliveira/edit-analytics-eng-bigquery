{% macro avg_metric(column_name, alias) %}
    round(avg({{ column_name }}), 2) as {{ alias }}
{% endmacro %}
