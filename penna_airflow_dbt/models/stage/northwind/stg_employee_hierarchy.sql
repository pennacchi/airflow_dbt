WITH RECURSIVE EmployeeHierarchy AS (
  -- Higher hierarchy employee (no one above them)
  SELECT
    employee_id,
    reports_to,
    e.first_name || ' ' || e.last_name as employee_name,
    CAST(e.first_name || ' ' || e.last_name AS STRING) as hierarchy_path,
    1 as hierarchy_level
  FROM
    {{ ref('stg_employees') }} e 
  WHERE reports_to IS NULL

  UNION ALL
  
  -- Get recursively the employees where each iteracion is one level below
  -- and we get the name of the employees creating a path from the higher hierarchy
  -- to the lower
  SELECT
    e.employee_id,
    e.reports_to,
    e.first_name || ' ' || e.last_name as employee_name,
    eh.hierarchy_path || ' -> ' || e.first_name || ' '|| e.last_name as hierarchy_path,
    eh.hierarchy_level + 1 as hierarchy_level 
  FROM
    {{ ref('stg_employees') }} e
  INNER JOIN
    EmployeeHierarchy eh ON e.reports_to = eh.employee_id
)
SELECT * FROM EmployeeHierarchy