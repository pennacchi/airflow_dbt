with dim_shipper as (
  select * from {{ ref('int_dim_shippers') }}
)
select * from dim_shipper