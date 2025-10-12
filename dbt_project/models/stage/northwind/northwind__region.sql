with source as (
  select 
      'northwind||' || region_id as region_id
    , region_description
  from {{ source('northwind', 'aws_s3__erp_northwind__region') }}
)

select * from source