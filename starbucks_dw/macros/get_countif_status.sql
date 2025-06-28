{% macro countif_status(column, status, alias) %}
    countif({{ column }} = '{{ status }}') as {{ alias }}
{% endmacro %}
