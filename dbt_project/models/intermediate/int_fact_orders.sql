/*
--------------------------------------------------------------------------------------------------
To create the fact_orders table, we need to join the order_resume table with the order_details table.
This join would create a replication of our freight column for each order_detail row.
We decided to create each freight as a product.
So we first create our order_and_details table and then add the freight as a product.
--------------------------------------------------------------------------------------------------
*/

with order_and_details_erp_new_system as (
    select 
      s.sale_id         as order_id
    , s.customer_id     as customer_id
    , s.salesperson_id  as salesperson_id
    , s.sale_date       as order_date
    , sd.product_id     as product_id
    , sd.price_per_unit as unit_price
    , sd.qty            as quantity
    , sd.discount_percentage                                       as product_discount_percentage
    , (sd.price_per_unit * sd.qty)                                 as product_sales_revenue
    , (sd.price_per_unit * sd.qty) * (sd.discount_percentage)      as product_discount_value
    , (sd.price_per_unit * sd.qty)                                 as gross_revenue
    , (sd.price_per_unit * sd.qty) * (1 - sd.discount_percentage)  as net_revenue
    , s.required_delivery_date                                     as required_date
    , s.shipped_date                                               as shipped_date
    , s.shipped_flag
    , s.delayed_flag
    , s.delayed_days
    , s.shipping_time
    , s.ship_via
    , a.ship_name
    , a.ship_address
    , a.ship_city
    , a.ship_region
    , a.ship_postal_code
    , a.ship_country
  from {{ ref('erp_new_system__sales') }} as s
  left join {{ ref('erp_new_system__sales_details') }} as sd on sd.sale_id = s.sale_id
  left join {{ ref("erp_new_system__address") }} as a on s.ship_address_id = a.address_id
  
)
, freight_as_order_and_details_erp_new_system as (
    select 
      s.sale_id                   as order_id
    , s.customer_id               as customer_id
    , s.salesperson_id            as salesperson_id
    , s.sale_date                 as order_date
    , 'erp_new_system||P021'      as product_id
    , s.freight_value             as unit_price
    , 1                           as quantity
    , 0                           as product_discount_percentage
    , 0                           as product_sales_revenue
    , 0                           as product_discount_value
    , s.freight_value             as gross_revenue
    , s.freight_value             as net_revenue
    , s.required_delivery_date    as required_date
    , s.shipped_date              as shipped_date
    , s.shipped_flag
    , s.delayed_flag
    , s.delayed_days
    , s.shipping_time
    , s.ship_via
    , a.ship_name
    , a.ship_address
    , a.ship_city
    , a.ship_region
    , a.ship_postal_code
    , a.ship_country
  from {{ ref('erp_new_system__sales') }} as s
  left join {{ ref("erp_new_system__address") }} as a on s.ship_address_id = a.address_id
)
/*
--------------------------------------------------------------------------------------------------
To create the fact_orders table, we need to join the order_resume table with the order_details table.
This join would create a replication of our freight column for each order_detail row.
We decided to create each freight as a product.
So we first create our order_and_details table and then add the freight as a product.
--------------------------------------------------------------------------------------------------
*/
, order_and_details_northwind as (
    select 
      o.order_id
    , o.customer_id
    , o.employee_id as salesperson_id
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
    , sv.description as ship_via
    , o.ship_name
    , o.ship_address
    , o.ship_city
    , o.ship_region
    , o.ship_postal_code
    , o.ship_country
  from {{ ref('northwind__orders') }} as o
  left join {{ ref('northwind__order_details') }} as od on o.order_id = od.order_id
  left join {{ ref('northwind__ship_via') }} as sv on o.ship_via_id = sv.ship_via_id
)
, freight_as_order_detail_northwind as (
    select 
        order_id
      , customer_id
      , employee_id as salesperson_id
      , order_date
      , 'northwind||78' as product_id
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
      , sv.description as ship_via
      , ship_name
      , ship_address
      , ship_city
      , ship_region
      , ship_postal_code
      , ship_country
    from {{ ref('northwind__orders') }} as o
    left join {{ ref('northwind__ship_via') }} as sv on o.ship_via_id = sv.ship_via_id
)
, fact_orders as (
  select * from order_and_details_northwind
  union all
  select * from freight_as_order_detail_northwind
  union all
  select * from order_and_details_erp_new_system
  union all
  select * from freight_as_order_and_details_erp_new_system
)
select * from fact_orders