with source as (
  select 
      'northwind||' || region_id as region_id
    , region_description
  from {{ source('northwind', 'region') }}
)

select * from source