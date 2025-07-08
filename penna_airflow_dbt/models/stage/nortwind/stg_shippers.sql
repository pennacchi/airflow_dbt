with source as (
  select * from {{ source('nortwind', 'shippers') }}
)

select * from source