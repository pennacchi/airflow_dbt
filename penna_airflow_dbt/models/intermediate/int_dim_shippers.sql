with dim_shipper as (
  select 
      shipper_id
    , company_name as shipper
    , phone
  from {{ ref('stg_shippers') }}
)
select * from dim_shipper