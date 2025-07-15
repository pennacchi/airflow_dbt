with source as (
  select 
      address_id
    , ship_name
    , ship_address
    , ship_city
    , ship_region
    , ship_postal_code
    , ship_country
  from {{ source('erp_new_system', 'new_address') }}
) 

select * from source