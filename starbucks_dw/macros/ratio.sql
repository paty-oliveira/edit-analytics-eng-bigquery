{% macro ratio(numerator_cond, denominator_cond, alias_name) %}
  case
    when {{ count_distinct_cond(denominator_cond) }} > 0
    then {{ count_distinct_cond(numerator_cond) }} * 1.0 / {{ count_distinct_cond(denominator_cond) }}
    else 0
  end as {{ alias_name }}
{% endmacro %}
