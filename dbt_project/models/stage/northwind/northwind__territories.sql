with source as (
  select 
      'northwind||' || territory_id as territory_id
    , territory_description
    , region_id
  from {{ source('northwind', 'aws_s3__erp_northwind__territories') }}
)

select * from source