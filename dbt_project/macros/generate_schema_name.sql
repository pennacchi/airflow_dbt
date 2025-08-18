{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    
    {# Lógica para SEDS: ignora o target e usa apenas o nome customizado #}
    {%- if node.resource_type == 'seed' -%}

        {%- if custom_schema_name is none -%}
            {{ default_schema }}
        {%- else -%}
            {{ custom_schema_name | trim }}
        {%- endif -%}

    {# Lógica padrão para todos os outros recursos (models, etc.) #}
    {%- else -%}

        {%- if custom_schema_name is none -%}
            {{ default_schema }}
        {%- else -%}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}