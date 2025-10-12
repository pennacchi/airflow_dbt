with dim_customer_northwind as (
  select 
      customer_id                      as customer_id
    , company_name                     as customer
    , contact_name                     as customer_contact_name
    , contact_title                    as customer_contact_title
    , address                          as customer_address
    , city                             as customer_city
    , region                           as customer_region
    , postal_code                      as customer_postal_code
    , country                          as customer_country
    , phone                            as customer_phone
    , fax                              as customer_fax
    , 'northwind'                      as source
  from {{ ref('northwind__customers') }}
)
, dim_customers_erp_new_system as (
  select 
      customer_id                      as customer_id
    , company_name                     as customer
    , contact_name                     as customer_contact_name
    , ''                               as customer_contact_title
    , ''                               as customer_address
    , ''                               as customer_city
    , ''                               as customer_region
    , ''                               as customer_postal_code
    , ''                               as customer_country
    , ''                               as customer_phone
    , ''                               as customer_fax
    , 'erp_new_system'                 as source
  from {{ ref('erp_new_system__customers') }}
)
, dim_customers as (
  select * from dim_customer_northwind
  union all
  select * from dim_customers_erp_new_system
)
select * from dim_customers