{% macro customer_response_base(table_alias, promo_col='promo_id', transaction_col='transaction_id') %}
    COUNT(DISTINCT CASE WHEN {{ table_alias }}.{{ promo_col }} IS NOT NULL THEN {{ table_alias }}.{{ transaction_col }} END) AS promo_trans_count,
    COUNT(DISTINCT {{ table_alias }}.{{ transaction_col }}) AS total_trans_count,
    ROUND(
      SAFE_DIVIDE(
        COUNT(DISTINCT CASE WHEN {{ table_alias }}.{{ promo_col }} IS NOT NULL THEN {{ table_alias }}.{{ transaction_col }} END),
        NULLIF(COUNT(DISTINCT {{ table_alias }}.{{ transaction_col }}), 0)
      ), 2
    ) AS pct_promo_response
{% endmacro %}
