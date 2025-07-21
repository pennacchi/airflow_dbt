with source as (
  select 
      'northwind||' || product_id as product_id
    , product_name
    , 'northwind||' || supplier_id as supplier_id
    , 'northwind||' || category_id as category_id
    , quantity_per_unit
    , unit_price
    , units_in_stock
    , units_on_order
    , reorder_level
    , discontinued
  from {{ source('northwind', 'products') }}
)
select * from source