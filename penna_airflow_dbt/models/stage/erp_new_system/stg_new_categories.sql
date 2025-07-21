with source as (
  select 
      'erp_new_system||' || category_id as category_id
    , category_name
  from {{ source('erp_new_system', 'new_categories') }}
)
select * from source