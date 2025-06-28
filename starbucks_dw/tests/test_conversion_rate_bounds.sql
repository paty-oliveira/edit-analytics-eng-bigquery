SELECT *
FROM {{ ref('rpt_channel_effectiveness') }}
WHERE response_rate < 0 OR response_rate > 1
