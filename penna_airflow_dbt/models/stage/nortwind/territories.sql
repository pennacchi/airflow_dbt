with source as (
  select * from {{ source('nortwind', 'territories') }}
)

select * from source