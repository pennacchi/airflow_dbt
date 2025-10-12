with source as (
  select 
      'northwind||' || category_id as category_id
    , category_name
    , description
    , picture
  from {{ source('northwind', 'aws_s3__erp_northwind__categories') }}
)

select * from source