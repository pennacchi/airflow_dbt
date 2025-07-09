with dim_customers as (
  select * from {{ ref('stg_customers') }}
)
select * from dim_customers