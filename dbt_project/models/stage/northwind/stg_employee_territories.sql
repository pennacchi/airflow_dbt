with source as (
  select 
      'northwind||' || employee_id as employee_id
    , 'northwind||' || territory_id as territory_id
  from {{ source('northwind', 'employee_territories') }}
)
select * from source