{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- set raw_prefix = var('schema_prefix', none) -%}
    {%- set custom_prefix = raw_prefix | trim if raw_prefix is not none else none -%}

    {%- if custom_schema_name is none -%}
        {%- if custom_prefix -%}
            {{ custom_prefix ~ '_' ~ default_schema }}
        {%- else -%}
            {{ default_schema }}
        {%- endif -%}
    {%- else -%}
        {{ custom_schema_name }}
    {%- endif -%}
{%- endmacro %}
