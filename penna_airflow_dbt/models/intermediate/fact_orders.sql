with orders as (
  select 
      o.order_id
    , o.customer_id
    , o.employee_id
    , o.order_date
    , od.product_id
    , p.product_name
    , od.unit_price
    , od.quantity
    , od.discount
    , o.freight
    , (od.unit_price * od.quantity)                                  as product_sales_revenue
    , (od.unit_price * od.quantity) + o.freight                      as gross_revenue
    , (od.unit_price * od.quantity) * (1 - od.discount) + o.freight  as net_revenue
    , o.required_date
    , o.shipped_date
    , case 
        when o.shipped_date is not null 
        then 'Yes' 
        else 'No' 
      end as shipped
    , case 
        when DATE_DIFF(o.shipped_date, o.required_date, DAY) > 0 
        then 'Yes'
        else 'No'
      end as delayed
    , case 
        when DATE_DIFF(o.shipped_date, o.required_date, DAY) > 0 
          then DATE_DIFF(o.shipped_date, o.required_date, DAY)
        else NULL
      end as delayed_days
    , case
        when o.shipped_date is not null 
        then DATE_DIFF(o.shipped_date, o.order_date, DAY)
        else NULL
      end as shipping_time
    , o.ship_via
    , o.ship_name
    , o.ship_address
    , o.ship_city
    , o.ship_region
    , o.ship_postal_code
    , o.ship_country
  from {{ ref('orders') }} as o
  left join {{ ref('order_details') }} as od on o.order_id = od.order_id
  left join {{ ref('products') }} as p on od.product_id = p.product_id
)