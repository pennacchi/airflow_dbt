with source as (
  select 
      'northwind||' || state_id as state_id
    , state_name
    , state_abbr
    , state_region
  from {{ source('northwind', 'aws_s3__erp_northwind__us_states') }}
)

select * from source