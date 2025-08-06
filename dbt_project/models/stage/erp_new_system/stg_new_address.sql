with source as (
  select 
      'erp_new_system||' || address_id as address_id
    , ship_name
    , ship_address
    , ship_city
    , ship_region
    , cast(ship_postal_code as string) as ship_postal_code 
    , ship_country
  from {{ source('erp_new_system', 'new_address') }}
) 
select * from source