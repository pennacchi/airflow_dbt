with source as (
  select * from {{ source('nortwind', 'customers') }}
)

select * from source