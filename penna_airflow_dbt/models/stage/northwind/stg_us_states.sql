with source as (
  select 
      'northwind||' || state_id as state_id
    , state_name
    , state_abbr
    , state_region
  from {{ source('northwind', 'us_states') }}
)

select * from source