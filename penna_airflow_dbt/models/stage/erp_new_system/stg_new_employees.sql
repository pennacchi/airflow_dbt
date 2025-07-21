with source as (
  select 
      'erp_new_system||' || employee_id as employee_id
    , name
    , title
    , boss_id
  from {{ source('erp_new_system', 'new_employees') }}
) 
select * from source