with source as (
  select 
      'northwind||' || employee_id as employee_id
    , last_name
    , first_name
    , title
    , title_of_courtesy
    , birth_date
    , hire_date
    , address
    , city
    , region
    , postal_code
    , country
    , home_phone
    , extension
    , photo
    , notes
    , 'northwind||' || reports_to as reports_to
  from {{ source('northwind', 'employees') }}
)

select * from source