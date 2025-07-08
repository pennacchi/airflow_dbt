with source as (
  select * from {{ source('northwind', 'territories') }}
)

select * from source