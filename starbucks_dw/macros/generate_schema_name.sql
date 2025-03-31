{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- set custom_prefix = var('schema_prefix') -%}

    {%- if custom_schema_name is none -%} {{ default_schema }}

    {%- else -%}
        {{ custom_prefix | trim ~ '_' ~ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}
