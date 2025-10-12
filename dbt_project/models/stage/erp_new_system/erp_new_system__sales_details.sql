with source as (
  select 
      'erp_new_system||' || sale_id as sale_id
    , 'erp_new_system||' || product_id as product_id
    , price_per_unit
    , qty
    , discount_percentage
    , deleted
  from {{ source('erp_new_system', 'aws_s3__erp_new_system__new_sales_details') }}
)
select * from source