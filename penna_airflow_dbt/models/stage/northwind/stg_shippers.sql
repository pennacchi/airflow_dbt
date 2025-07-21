with source as (
  select 
      'northwind||' || shipper_id as shipper_id
    , company_name
    , phone
  from {{ source('northwind', 'shippers') }}
)

select * from source