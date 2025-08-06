with dim_customers as (
  select * from {{ ref('int_dim_customers') }}
)
select * from dim_customers