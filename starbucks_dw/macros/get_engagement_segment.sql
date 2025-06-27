{% macro engagement_segment(unique_transaction_sessions, column_name) %}
    case
        when {{ unique_transaction_sessions }} >= 15 then 'Highly Engaged'
        when {{ unique_transaction_sessions }} >= 8 then 'Moderately Engaged'
        when {{ unique_transaction_sessions }} >= 3 then 'Lightly Engaged'
        when {{ unique_transaction_sessions }} > 0 then 'Minimally Engaged'
        else 'Not Engaged'
    end as {{ column_name }}
{% endmacro %}
