{% macro get_date_parts(date_column, prefix) %}
    extract(year from {{ date_column }}) as {{ prefix }}_year,
    extract(month from {{ date_column }}) as {{ prefix }}_month,
    extract(day from {{ date_column }}) as {{ prefix }}_day,
    extract(dayofweek from {{ date_column }}) as {{ prefix }}_dayofweek
{% endmacro %}
