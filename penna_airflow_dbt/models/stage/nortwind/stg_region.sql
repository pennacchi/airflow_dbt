with source as (
  select * from {{ source('nortwind', 'region') }}
)

select * from source