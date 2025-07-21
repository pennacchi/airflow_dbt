with source as (
  select 
      'erp_new_system||' || sale_id as sale_id
    , 'erp_new_system||' || customer_id as customer_id
    , 'erp_new_system||' || salesperson_id as salesperson_id
    , sale_date
    , freight_value
    , required_delivery_date
    , shipped_date
    , case 
        when shipped_date is not null
        then 'Yes' 
        else 'No' 
      end as shipped_flag
    , case 
        when DATE_DIFF(shipped_date, required_delivery_date, DAY) > 0 
        then 'Yes'
        else 'No'
      end as delayed_flag
    , case 
        when DATE_DIFF(shipped_date, required_delivery_date, DAY) > 0 
          then DATE_DIFF(shipped_date, required_delivery_date, DAY)
        else NULL
      end as delayed_days
    , case
        when shipped_date is not null 
        then DATE_DIFF(shipped_date, sale_date, DAY)
        else NULL
      end as shipping_time
    , ship_via
    , ship_address_id
  from {{ source('erp_new_system', 'new_sales') }}
)
select * from source