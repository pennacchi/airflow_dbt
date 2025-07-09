with dim_shipper as (
  select * from {{ ref('stg_shippers') }}
)
select * from dim_shipper