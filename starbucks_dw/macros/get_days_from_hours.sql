{% macro get_days_from_hours(hour) %}
    case when {{ hour }} < 24 then 0 else {{ hour }} / 24 end
{% endmacro %}
