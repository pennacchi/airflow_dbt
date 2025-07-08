with source as (
  select * from {{ source('northwind', 'employee_territories') }}
)

select * from source