with source as (
  select * from {{ source('northwind', 'region') }}
)

select * from source