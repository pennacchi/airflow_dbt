with source as (
  select 
      'erp_new_system||' || product_id as product_id
    , name
    , 'erp_new_system||' || category_id as category_id
    , 'erp_new_system||' || supplier_id as supplier_id
  from {{ source('erp_new_system', 'aws_s3__erp_new_system__new_products') }}
) 

select * from source