{% macro segment_by_interval(column, intervals, labels, default_label='Unknown') %}
  CASE 
    {%- for i in range(intervals | length) %}
      {%- if i == 0 %}
    WHEN {{ column }} < {{ intervals[i] }} THEN '{{ labels[i] }}'
      {%- elif i == intervals | length - 1 %}
    WHEN {{ column }} BETWEEN {{ intervals[i-1] }} AND {{ intervals[i] }} THEN '{{ labels[i] }}'
    WHEN {{ column }} > {{ intervals[i] }} THEN '{{ labels[i+1] }}'
      {%- else %}
    WHEN {{ column }} BETWEEN {{ intervals[i-1] }} AND {{ intervals[i] }} THEN '{{ labels[i] }}'
      {%- endif %}
    {%- endfor %}
    ELSE '{{ default_label }}'
  END
{% endmacro %}
