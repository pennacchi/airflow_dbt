with source as (
  select 
      'northwind||' || order_id as order_id
    , product_id
    , unit_price
    , quantity
    , discount
  from {{ source('northwind', 'order_details') }}
)
select * from source