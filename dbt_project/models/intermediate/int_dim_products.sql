with dim_products_northwind as (
  select 
      p.product_id           as product_id
    , p.product_name         as product
    , p.category_id          as category_id
    , c.category_name        as product_category
    , c.description          as product_category_description
    , p.supplier_id          as supplier_id
    , s.company_name         as product_supplier
    , p.quantity_per_unit    as product_quantity_per_unit
    , p.unit_price           as product_unit_price
    , p.units_in_stock       as product_units_in_stock
    , p.units_on_order       as product_units_on_order
    , p.reorder_level        as product_reorder_level
    , p.discontinued         as product_discontinued
    , 'northwind'            as product_source
   from {{ ref('northwind__products') }} as p
   left join {{ ref('northwind__categories') }} as c on p.category_id = c.category_id
   left join {{ ref('northwind__suppliers') }} as s on p.supplier_id = s.supplier_id
)
, dim_products_erp_new_system as (
  select 
      p.product_id          as product_id
    , p.name                as product
    , p.category_id         as category_id
    , c.category_name       as product_category
    , c.category_name       as product_category_description
    , p.supplier_id         as supplier_id
    , s.supplier_name       as product_supplier
    , ''                    as product_quantity_per_unit
    , CAST(NULL as FLOAT64) as product_unit_price
    , CAST(NULL as INT64)   as product_units_in_stock
    , CAST(NULL as INT64)   as product_units_on_order
    , CAST(NULL as INT64)   as product_reorder_level
    , 0                     as product_discontinued
    , 'erp_new_system'      as product_source
   from {{ ref('erp_new_system__products') }} as p
   left join {{ ref('erp_new_system__categories') }} as c on p.category_id = c.category_id
   left join {{ ref('erp_new_system__suppliers') }} as s on p.supplier_id = s.supplier_id
)
, dim_products as (
  select * from dim_products_northwind
  union all
  select * from dim_products_erp_new_system
)
select * from dim_products