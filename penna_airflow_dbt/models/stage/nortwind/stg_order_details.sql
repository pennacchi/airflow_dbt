with source as (
  select * from {{ source('nortwind', 'order_details') }}
)

select * from source