With dim_employees_erp_new_system as (
  select 
      e.employee_id                       as employee_id
    , e.name                              as employee
    , e.title                             as employee_title
    , cast(NULL as TIMESTAMP)             as employee_birth_date
    , cast(NULL as TIMESTAMP)             as employee_hire_date
    , e.boss_id                           as employee_reports_to
    , eh.hierarchy_level                  as employee_hierarchy_level
    , CASE
      	WHEN eh.hierarchy_level >= 1 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(0)]
      	else ''
      END AS employee_superior_level_1
    , CASE
      	WHEN eh.hierarchy_level >= 2 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(1)]
      	else ''
      END AS employee_superior_level_2
    , CASE
      	WHEN eh.hierarchy_level >= 3 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(2)]
      	else ''
      END AS employee_superior_level_3
    , CASE
      	WHEN eh.hierarchy_level >= 4 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(3)]
      	else ''
      END AS employee_superior_level_4
    , eh.hierarchy_path
    , 'erp_new_system'                    as employee_source
  from {{ ref('erp_new_system__employees') }} e
  left join {{ ref('erp_new_system__employee_hierarchy') }} eh 
    on eh.employee_id = e.employee_id
)
, dim_employees_northwind as (
  SELECT
      eh.employee_id      as employee_id
    , eh.employee_name    as employee
    , e.title             as employee_title
    , e.birth_date        as employee_birth_date
    , e.hire_date         as employee_hire_date
    , eh.reports_to       as employee_reports_to
    , eh.hierarchy_level  as employee_hierarchy_level
    , CASE
      	WHEN eh.hierarchy_level >= 1 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(0)]
      	else ''
      END AS employee_superior_level_1
    , CASE
      	WHEN eh.hierarchy_level >= 2 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(1)]
      	else ''
      END AS employee_superior_level_2
    , CASE
      	WHEN eh.hierarchy_level >= 3 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(2)]
      	else ''
      END AS employee_superior_level_3
    , CASE
      	WHEN eh.hierarchy_level >= 4 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(3)]
      	else ''
      END AS employee_superior_level_4
    , eh.hierarchy_path
    , 'northwind'          as employee_source
  FROM {{ ref('northwind__employees') }} e
  LEFT JOIN {{ ref('northwind__employee_hierarchy') }} eh
    ON eh.employee_id = e.employee_id
) 
, dim_employees as (
  select * from dim_employees_erp_new_system
  union all
  select * from dim_employees_northwind
)
select * from dim_employees
