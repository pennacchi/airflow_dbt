with source as (
  select 
      'erp_new_system||' || customer_id as customer_id
    , company_name
    , contact_name
  from {{ source('erp_new_system', 'new_customers') }}
) 

select * from source