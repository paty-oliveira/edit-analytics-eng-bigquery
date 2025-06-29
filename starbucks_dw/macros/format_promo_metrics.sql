{% macro promo_metrics(table_alias, status_received='received', status_viewed='viewed', transaction_id='transaction_id', transaction_status='transaction_status') %}
  COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_received }}') AS promos_received,
  COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_viewed }}') AS promos_viewed,
  COUNT({{ table_alias }}.{{ transaction_id }}) AS total_transactions,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_viewed }}'),
      NULLIF(COUNTIF({{ table_alias }}.{{ transaction_status }} = '{{ status_received }}'), 0)
    ),
    2
  ) AS view_rate,
  ROUND(COALESCE(AVG({{ table_alias }}.hours_since_start), 0), 2) AS avg_hours_since_start,
  ROUND(COALESCE(AVG({{ table_alias }}.days_since_start), 0), 2) AS avg_days_since_start
{% endmacro %}
