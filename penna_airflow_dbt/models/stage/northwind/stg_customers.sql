with source as (
  select * from {{ source('northwind', 'customers') }}
)

select * from source