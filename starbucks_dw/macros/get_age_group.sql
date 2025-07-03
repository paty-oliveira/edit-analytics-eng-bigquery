{% macro age_group(age, column_name) %}
    case
        when {{ age }} < 26 then '18-25'
        when {{ age }} < 36 then '26-35'
        when {{ age }} < 46 then '36-45'
        when {{ age }} < 56 then '46-55'
        when {{ age }} < 66 then '56-65'
        when {{ age }} < 76 then '66-75'
        when {{ age }} < 86 then '76-85'
        else '86+'
    end as {{ column_name }}
{% endmacro %}
