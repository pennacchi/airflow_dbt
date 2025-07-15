with source as (
  select 
      employee_id
    , name
    , title
    , boss_id
  from {{ source('erp_new_system', 'new_employees') }}
) 

select * from source