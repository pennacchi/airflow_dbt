with source as (
  select * from {{ source('nortwind', 'us_states') }}
)

select * from source