with source as (
  select 
      'erp_new_system||' || address_id as address_id
    , ship_name
    , ship_address
    , ship_city
    , ship_region
    , cast(ship_postal_code as string) as ship_postal_code 
    , ship_country
    , 1 as test_new_column_git_hub_action____please_remove_this_column
  from {{ source('erp_new_system', 'aws_s3__erp_new_system__new_address') }}
) 
select * from source