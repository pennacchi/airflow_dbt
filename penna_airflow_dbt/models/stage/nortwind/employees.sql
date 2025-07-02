with source as (
  select * from {{ source('nortwind', 'employees') }}
)

select * from source