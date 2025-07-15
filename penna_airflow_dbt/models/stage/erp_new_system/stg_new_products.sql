with source as (
  select 
      product_id
    , name
  from {{ source('erp_new_system', 'new_products') }}
) 

select * from source