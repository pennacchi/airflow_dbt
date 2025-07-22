/*
--------------------------------------------------------------------------------------------------
To create the fact_orders table, we need to join the order_resume table with the order_details table.
This join would create a replication of our freight column for each order_detail row.
We decided to create each freight as a product.
So we first create our order_and_details table and then add the freight as a product.
--------------------------------------------------------------------------------------------------
*/

with order_and_details as (
    select 
      o.order_id
    , o.customer_id
    , o.employee_id
    , o.order_date
    , od.product_id
    , od.unit_price
    , od.quantity
    , od.discount                                        as product_discount_percentage
    , (od.unit_price * od.quantity)                      as product_sales_revenue
    , (od.unit_price * od.quantity) * (od.discount)      as product_discount_value
    , (od.unit_price * od.quantity)                      as gross_revenue
    , (od.unit_price * od.quantity) * (1 - od.discount)  as net_revenue
    , o.required_date
    , o.shipped_date
    , o.shipped_flag
    , o.delayed_flag
    , o.delayed_days
    , o.shipping_time
    , o.ship_via
    , o.ship_name
    , o.ship_address
    , o.ship_city
    , o.ship_region
    , o.ship_postal_code
    , o.ship_country
  from {{ ref('stg_orders') }} as o
  left join {{ ref('stg_order_details') }} as od on o.order_id = od.order_id
)
, freight_as_order_detail as (
    select 
        order_id
      , customer_id
      , employee_id
      , order_date
      , 78 as product_id
      , freight as unit_price
      , 1 as quantity
      , 0 as product_discount_percentage
      , 0 as product_sales_revenue
      , 0 as product_discount_value
      , freight as gross_revenue
      , freight as net_revenue
      , required_date
      , shipped_date
      , shipped_flag
      , delayed_flag
      , delayed_days
      , shipping_time
      , ship_via
      , ship_name
      , ship_address
      , ship_city
      , ship_region
      , ship_postal_code
      , ship_country
    from {{ ref('stg_orders') }} as o
)
, fact_orders as (
  select * from order_and_details
  union all
  select * from freight_as_order_detail
)
select * from fact_orders