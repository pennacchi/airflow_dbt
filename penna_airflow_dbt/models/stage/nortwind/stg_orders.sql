with source as (
  select * from {{ source('nortwind', 'orders') }}
)

select * from source