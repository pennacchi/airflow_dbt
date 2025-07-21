with source as (
  select 
      'erp_new_system||' || supplier_id as supplier_id
    , supplier_name
    , contact_person
    , phone
    , email
  from {{ source('erp_new_system', 'new_suppliers') }}
)
select * from source