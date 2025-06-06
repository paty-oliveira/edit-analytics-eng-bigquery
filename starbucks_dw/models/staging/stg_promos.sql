with
    transformed as (
        select
            id as promo_id,
            reward,
            duration,
            difficulty as difficulty_rank,
            offer_type as promo_type,
            json_value_array(REPLACE(channels, "'", '"')) as channels,
            current_timestamp as ingested_at
        from {{ source('starbucks', 'promos')}}
    )

select *
from transformed
