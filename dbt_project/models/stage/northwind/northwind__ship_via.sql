with source as (
  select 
      'northwind||' || ship_via_id as ship_via_id
    , description
from {{ source('northwind', 'aws_s3__erp_northwind__ship_via') }}
)
select * from source