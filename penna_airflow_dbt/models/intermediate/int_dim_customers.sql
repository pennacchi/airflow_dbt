with dim_customer_northwind as (
  select 
      customer_id                      as customer_id
    , company_name                     as company_name
    , contact_name                     as contact_name
    , contact_title                    as contact_title
    , address                          as address
    , city                             as city
    , region                           as region
    , postal_code                      as postal_code
    , country                          as country
    , phone                            as phone
    , fax                              as fax
    , 'northwind'                      as source
  from {{ ref('stg_customers') }}
)
, dim_customers_erp_new_system as (
  select 
      customer_id                      as customer_id
    , company_name                     as company_name
    , contact_name                     as contact_name
    , ''                               as contact_title
    , ''                               as address
    , ''                               as city
    , ''                               as region
    , ''                               as postal_code
    , ''                               as country
    , ''                               as phone
    , ''                               as fax
    , 'erp_new_system'                 as source
  from {{ ref('stg_new_customers') }}
)
, dim_customers as (
  select * from dim_customer_northwind
  union all
  select * from dim_customers_erp_new_system
)
select * from dim_customers