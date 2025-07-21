with dim_products_northwind as (
  select 
      p.product_id  as product_id
    , p.product_name  as product
    , p.category_id
    , c.category_name as category
    , c.description   as category_description
    , p.supplier_id as supplier_id
    , s.company_name  as supplier
    , p.quantity_per_unit
    , p.unit_price
    , p.units_in_stock
    , p.units_on_order
    , p.reorder_level
    , p.discontinued
    , 'northwind' as source
   from {{ ref('stg_products') }} as p
   left join {{ ref('stg_categories') }} as c on p.category_id = c.category_id
   left join {{ ref('stg_suppliers') }} as s on p.supplier_id = s.supplier_id
)
, dim_products_erp_new_system as (
  select 
      p.product_id  as product_id
    , p.name  as product
    , p.category_id
    , c.category_name as category
    , c.category_name as category_description
    , p.supplier_id as supplier_id
    , s.supplier_name  as supplier
    , '' as quantity_per_unit
    , CAST(NULL as FLOAT64) as unit_price
    , CAST(NULL as INT64) as units_in_stock
    , CAST(NULL as INT64) as units_on_order
    , CAST(NULL as INT64) as reorder_level
    , 0 as discontinued
    , 'erp_new_system' as source
   from {{ ref('stg_new_products') }} as p
   left join {{ ref('stg_new_categories') }} as c on p.category_id = c.category_id
   left join {{ ref('stg_new_suppliers') }} as s on p.supplier_id = s.supplier_id
)
, dim_products as (
  select * from dim_products_northwind
  union all
  select * from dim_products_erp_new_system
)
select * from dim_products