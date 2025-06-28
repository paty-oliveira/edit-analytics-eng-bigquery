{% macro promo_metrics(table_alias, status_received='received', status_viewed='viewed', transaction_id='transaction_id', transaction_status='transaction_status') %}
  COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_received }}') AS promos_received,
  COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_viewed }}') AS promos_viewed,
  COUNT({{ table_alias }}.{{ transaction_id }}) AS total_transactions,
  SAFE_DIVIDE(
    COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_viewed }}'),
    NULLIF(COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_received }}'), 0)
  ) AS view_rate
{% endmacro %}
