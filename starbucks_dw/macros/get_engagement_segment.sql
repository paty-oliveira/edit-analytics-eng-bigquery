{% macro engagement_segment(total_events, column_name) %}
    case
        when {{ total_events }} >= 15 then 'Highly Engaged'
        when {{ total_events }} >= 8 then 'Moderately Engaged'
        when {{ total_events }} >= 3 then 'Lightly Engaged'
        when {{ total_events }} > 0 then 'Minimally Engaged'
        else 'Not Engaged'
    end as {{ column_name }}
{% endmacro %}
