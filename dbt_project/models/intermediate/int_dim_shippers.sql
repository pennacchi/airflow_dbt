/*
--------------------------------------------------------------------------------------------------
Only for Northwind
--------------------------------------------------------------------------------------------------
*/
with dim_shipper as (
  select 
      shipper_id
    , company_name as shipper
    , phone        as shipper_phone
    , 'northwind'  as shipper_source
  from {{ ref('northwind__shippers') }}
)
select * from dim_shipper