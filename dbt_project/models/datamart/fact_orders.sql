{{
  config(
    materialized='table',
    partition_by={
      'field': 'order_date', 
      'data_type': 'datetime',
      'granularity': 'day'
    },
    cluster_by=['product_id']
  )
}}

with fact_orders as (
  select * from {{ ref('int_fact_orders') }}
)
select * from fact_orders