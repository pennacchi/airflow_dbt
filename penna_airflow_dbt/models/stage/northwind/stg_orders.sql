with source as (
  select 
      'northwind||' || order_id as order_id
    , 'northwind||' || customer_id as customer_id
    , 'northwind||' || employee_id as employee_id
    , order_date
    , freight
    , required_date
    , shipped_date
    , case 
        when shipped_date is not null 
        then 'Yes' 
        else 'No' 
      end as shipped_flag
    , case 
        when DATE_DIFF(shipped_date, required_date, DAY) > 0 
        then 'Yes'
        else 'No'
      end as delayed_flag
    , case 
        when DATE_DIFF(shipped_date, required_date, DAY) > 0 
          then DATE_DIFF(shipped_date, required_date, DAY)
        else NULL
      end as delayed_days
    , case
        when shipped_date is not null 
        then DATE_DIFF(shipped_date, order_date, DAY)
        else NULL
      end as shipping_time
    , ship_via
    , ship_name
    , ship_address
    , ship_city
    , ship_region
    , ship_postal_code
    , ship_country
  from {{ source('northwind', 'orders') }}
)

select * from source