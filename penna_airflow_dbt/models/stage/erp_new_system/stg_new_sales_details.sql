with source as (
  select * from {{ source('erp_new_system', 'new_sales_details') }}
)
select * from source