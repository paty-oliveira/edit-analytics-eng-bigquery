{% macro income_segment(income_column) %}
  case
    when {{ income_column }} < 50000 then 'Low Income'
    when {{ income_column }} between 50000 and 100000 then 'Middle Income'
    when {{ income_column }} > 100000 then 'High Income'
    else 'Unknown Income'
  end
{% endmacro %}
