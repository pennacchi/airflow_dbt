With dim_employees_erp_new_system as (
  select 
      'erp_new_system||' || e.employee_id as employee_id
    , e.name                              as employee_name
    , e.title                             as title
    , cast(NULL as DATE)                  as birth_date
    , cast(NULL as DATE)                  as hire_date
    , e.boss_id                           as reports_to
    , eh.hierarchy_level                  as hierarchy_level
    , CASE
      	WHEN eh.hierarchy_level >= 1 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(0)]
      	else ''
      END AS superior_level_1
    , CASE
      	WHEN eh.hierarchy_level >= 2 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(1)]
      	else ''
      END AS superior_level_2
    , CASE
      	WHEN eh.hierarchy_level >= 3 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(2)]
      	else ''
      END AS superior_level_3
    , CASE
      	WHEN eh.hierarchy_level >= 4 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(3)]
      	else ''
      END AS superior_level_4
    , eh.hierarchy_path
    , 'erp_new_system'                    as source
  from {{ ref('stg_new_employees') }} e
  left join {{ ref('stg_new_employee_hierarchy') }} eh 
    on eh.employee_id = e.employee_id
)
, dim_employees_northwind as (
  SELECT
      'erp_new_system||' || eh.employee_id  as employee_id
    , eh.employee_name
    , e.title
    , e.birth_date
    , e.hire_date
    , eh.reports_to
    , eh.hierarchy_level
    , CASE
      	WHEN eh.hierarchy_level >= 1 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(0)]
      	else ''
      END AS superior_level_1
    , CASE
      	WHEN eh.hierarchy_level >= 2 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(1)]
      	else ''
      END AS superior_level_2
    , CASE
      	WHEN eh.hierarchy_level >= 3 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(2)]
      	else ''
      END AS superior_level_3
    , CASE
      	WHEN eh.hierarchy_level >= 4 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(3)]
      	else ''
      END AS superior_level_4
    , eh.hierarchy_path
    , 'northwind' as source
  FROM {{ ref('stg_employees') }} e
  LEFT JOIN {{ ref('stg_employee_hierarchy') }} eh
    ON eh.employee_id = e.employee_id
) 
, dim_employees as (
  select * from dim_employees_erp_new_system
  union all
  select * from dim_employees_northwind
)
select * from dim_employees