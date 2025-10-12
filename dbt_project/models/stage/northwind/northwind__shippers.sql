with source as (
  select 
      'northwind||' || shipper_id as shipper_id
    , company_name
    , phone
  from {{ source('northwind', 'aws_s3__erp_northwind__shippers') }}
)

select * from source