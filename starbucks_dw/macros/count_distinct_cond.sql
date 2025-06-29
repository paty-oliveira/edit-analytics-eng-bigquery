{% macro count_distinct_cond(condition) %}
  count(distinct case when {{ condition }} then transaction_id end)
{% endmacro %}
