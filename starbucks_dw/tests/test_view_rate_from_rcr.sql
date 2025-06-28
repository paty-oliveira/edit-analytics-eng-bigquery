select *
from {{ ref('rep_customer_responsiveness') }}
where view_rate < 0
   or view_rate > 100
