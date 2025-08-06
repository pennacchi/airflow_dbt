with source as (
  select 
      'northwind||' || ship_via_id as ship_via_id
    , description
from {{ source('northwind', 'ship_via') }}
)
select * from source