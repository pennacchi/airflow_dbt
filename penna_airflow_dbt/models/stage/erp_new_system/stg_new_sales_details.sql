with source as (
  select 
      sale_id
    , product_id
    , price_per_unit
    , qty
    , discount_percentage
    , deleted
  from {{ source('erp_new_system', 'new_sales_details') }}
)
select * from source