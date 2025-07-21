with source as (
  select 
      'northwind||' || category_id as category_id
    , category_name
    , description
    , picture
  from {{ source('northwind', 'categories') }}
)

select * from source