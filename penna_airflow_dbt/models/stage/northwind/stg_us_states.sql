with source as (
  select * from {{ source('northwind', 'us_states') }}
)

select * from source