{% macro engagement_segment(completion_rate_col, total_offers_received_col) %}
  case
    when {{ completion_rate_col }} >= 0.7 and {{ total_offers_received_col }} >= 5 then 'High Performer'
    when {{ completion_rate_col }} >= 0.4 and {{ total_offers_received_col }} >= 3 then 'Engaged'
    when {{ completion_rate_col }} >= 0.1 and {{ total_offers_received_col }} >= 2 then 'Moderate'
    when {{ total_offers_received_col }} >= 1 and {{ completion_rate_col }} < 0.1 then 'Low Engagement'
    else 'No Engagement'
  end
{% endmacro %}
