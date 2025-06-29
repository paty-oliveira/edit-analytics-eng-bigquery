{% macro calculate_transaction_status_rate(numerator_status, denominator_status, alias_name) %}
  COALESCE(
    SAFE_DIVIDE(
      count(DISTINCT case WHEN transaction_status = '{{ numerator_status }}' THEN transaction_id END),
      count(DISTINCT case WHEN transaction_status = '{{ denominator_status }}' THEN transaction_id END)
    ),
    0
  ) AS {{ alias_name }}
{%- endmacro %}
