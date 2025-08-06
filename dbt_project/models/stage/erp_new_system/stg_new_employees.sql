with source as (
  select 
      'erp_new_system||' || employee_id as employee_id
    , name
    , title
    , 'erp_new_system||' || boss_id as boss_id
  from {{ source('erp_new_system', 'new_employees') }}
) 
select * from source