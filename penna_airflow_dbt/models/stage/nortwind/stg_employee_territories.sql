with source as (
  select * from {{ source('nortwind', 'employee_territories') }}
)

select * from source