/*
--------------------------------------------------------------------------------------------------
Only for Northwind
--------------------------------------------------------------------------------------------------
*/
with dim_shipper as (
  select 
      shipper_id
    , company_name as shipper
    , phone
    , 'northwind' as source
  from {{ ref('stg_shippers') }}
)
select * from dim_shipper