with fact_orders as (
  select * from {{ ref('int_fact_orders') }}
)
select * from fact_orders