with source as (
  select 
      'erp_new_system||' || customer_id as customer_id
    , company_name
    , contact_name
  from {{ source('erp_new_system', 'aws_s3__erp_new_system__new_customers') }}
) 

select * from source