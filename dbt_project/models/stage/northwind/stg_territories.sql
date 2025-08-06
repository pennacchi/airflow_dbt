with source as (
  select 
      'northwind||' || territory_id as territory_id
    , territory_description
    , region_id
  from {{ source('northwind', 'territories') }}
)

select * from source