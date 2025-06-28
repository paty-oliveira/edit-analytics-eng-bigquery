SELECT *
FROM {{ ref('rpt_customer_segmentation') }}
WHERE response_rate < 0 OR response_rate > 1
