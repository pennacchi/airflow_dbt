With Dim_Employee as (
  SELECT
      eh.employee_id,
      eh.employee_name,
      e_original.title,
      e_original.birth_date,
      e_original.hire_date,
      eh.reports_to,
      eh.hierarchy_level,
      CASE
      	WHEN eh.hierarchy_level >= 1 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(0)]
      	else ''
      END AS superior_level_1,
      CASE
      	WHEN eh.hierarchy_level >= 2 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(1)]
      	else ''
      END AS superior_level_2,
      CASE
      	WHEN eh.hierarchy_level >= 3 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(2)]
      	else ''
      END AS superior_level_3,
      CASE
      	WHEN eh.hierarchy_level >= 4 THEN SPLIT(eh.hierarchy_path, ' -> ')[OFFSET(3)]
      	else ''
      END AS superior_level_4,
      eh.hierarchy_path,
  FROM {{ ref('stg_employees') }} e_original
  LEFT JOIN {{ ref('stg_employee_hierarchy') }} eh
    ON eh.employee_id = e_original.employee_id
) 
select * from Dim_Employee