with source as (
  select * from {{ source('erp_new_system', 'new_employees') }}
) 

select * from source