with source as (
  select * from {{ source('nortwind', 'products') }}
)

select * from source