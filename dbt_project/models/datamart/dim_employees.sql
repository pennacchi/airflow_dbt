with dim_employees as (
  select * from {{ ref('int_dim_employees') }}
)
select * from dim_employees