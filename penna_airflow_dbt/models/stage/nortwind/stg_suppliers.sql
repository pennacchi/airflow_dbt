with source as (
  select * from {{ source('nortwind', 'suppliers') }}
)

select * from source