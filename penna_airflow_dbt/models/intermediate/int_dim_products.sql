with dim_products as (
  select 
      p.product_id
    , p.product_name  as product
    , p.category_id
    , c.category_name as category
    , c.description   as category_description
    , p.supplier_id
    , s.company_name  as supplier
    , p.quantity_per_unit
    , p.unit_price
    , p.units_in_stock
    , p.units_on_order
    , p.reorder_level
    , p.discontinued
   from {{ ref('products') }} as p
   left join {{ ref('categories') }} as c on p.category_id = c.category_id
   left join {{ ref('suppliers') }} as s on p.supplier_id = s.supplier_id
)
select * from dim_products