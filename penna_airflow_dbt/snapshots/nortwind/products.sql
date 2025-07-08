{% snapshot products_snapshot %}

{{
  config(
    unique_key='product_id',
    strategy='check',
    check_cols=['supplier_id', 'quantity_per_unit', 'unit_price', 'units_in_stock', 'units_on_order', 'reorder_level']
  )
}}



with source as (
  select 
      product_id
    , product_name
    , supplier_id
    , quantity_per_unit
    , unit_price
    , units_in_stock
    , units_on_order
    , reorder_level
  from {{ source('northwind', 'products') }}
)

select * from source

{% endsnapshot %}