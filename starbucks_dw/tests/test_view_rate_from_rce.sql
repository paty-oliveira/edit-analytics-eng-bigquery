select *
from {{ ref('rep_channel_effectiveness') }}
where view_rate < 0
   or view_rate > 100
