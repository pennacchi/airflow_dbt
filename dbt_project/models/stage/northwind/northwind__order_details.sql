with source as (
  select 
      'northwind||' || order_id   as order_id
    , 'northwind||' || product_id as product_id
    , unit_price
    , quantity
    , discount
  from {{ source('northwind', 'aws_s3__erp_northwind__order_details') }}
)
select * from source