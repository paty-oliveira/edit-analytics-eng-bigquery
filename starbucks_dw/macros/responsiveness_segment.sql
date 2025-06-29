{% macro responsiveness_segment(view_rate_col) %}
  case
    when {{ view_rate_col }} >= 0.8 then 'Highly Responsive'
    when {{ view_rate_col }} >= 0.5 then 'Moderately Responsive'
    when {{ view_rate_col }} >= 0.2 then 'Selective'
    else 'Unresponsive'
  end
{% endmacro %}
