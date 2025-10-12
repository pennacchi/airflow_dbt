with source as (
  select 
      'erp_new_system||' || category_id as category_id
    , category_name
  from {{ source('erp_new_system', 'aws_s3__erp_new_system__new_categories') }}
)
select * from source