{% macro subscription_age_segment(days_since_sub_column) %}
  case
    when {{ days_since_sub_column }} < 90 then '0-3 months'
    when {{ days_since_sub_column }} < 365 then '3-12 months'
    when {{ days_since_sub_column }} < 730 then '1-2 years'
    else '2+ years'
  end
{% endmacro %}
