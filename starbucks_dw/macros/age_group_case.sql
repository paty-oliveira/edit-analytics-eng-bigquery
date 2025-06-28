{% macro age_group_case(age_column='age', age_buckets=None) %}
  CASE
    {% for bucket in age_buckets %}
      WHEN {{ age_column }} BETWEEN {{ bucket[0] }} AND {{ bucket[1] }} THEN '{{ bucket[2] }}'
    {% endfor %}
    ELSE 'Unknown'
  END
{% endmacro %}
