with source as (
  select 
      'northwind||' || employee_id as employee_id
    , 'northwind||' || territory_id as territory_id
  from {{ source('northwind', 'aws_s3__erp_northwind__employee_territories') }}
)
select * from source