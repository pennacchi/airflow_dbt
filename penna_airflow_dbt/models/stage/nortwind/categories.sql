with source as (
  select * from {{ source('nortwind', 'categories') }}
)

select * from source