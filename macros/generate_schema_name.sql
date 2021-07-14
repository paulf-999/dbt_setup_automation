{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if target.name[-3:] == 'dev' -%}

        {{ target.schema }}_{{ custom_schema_name | trim }}

    {%- elif target.schema[:9] == 'dbt_cloud' -%}

        {{ target.schema }}_{{ custom_schema_name | trim }}

    {%- elif custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}