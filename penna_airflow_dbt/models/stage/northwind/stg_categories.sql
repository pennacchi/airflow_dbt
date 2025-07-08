with source as (
  select * from {{ source('northwind', 'categories') }}
)

select * from source