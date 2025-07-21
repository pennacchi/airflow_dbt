WITH RECURSIVE new_employee_hierarchy AS (
  -- Higher hierarchy employee (no one above them)
  SELECT
    e.employee_id as employee_id,
    e.boss_id as boss_id,
    e.name as employee_name,
    CAST(e.name AS STRING) as hierarchy_path,
    1 as hierarchy_level
  FROM
    {{ source('erp_new_system', 'new_employees') }} e 
  WHERE boss_id IS NULL

  UNION ALL
  
  -- Get recursively the employees where each iteracion is one level below
  -- and we get the name of the employees creating a path from the higher hierarchy
  -- to the lower
  SELECT
    e.employee_id as employee_id,
    e.boss_id as boss_id ,
    e.name as employee_name,
    eh.hierarchy_path || ' -> ' || e.name as hierarchy_path,
    eh.hierarchy_level + 1 as hierarchy_level 
  FROM
    {{ source('erp_new_system', 'new_employees') }} e
  INNER JOIN
    new_employee_hierarchy eh ON e.boss_id = eh.employee_id
)
, new_employees as (
  select 
      'erp_new_system||' || employee_id as employee_id
    , 'erp_new_system||' || boss_id as boss_id
    , employee_name
    , hierarchy_path
    , hierarchy_level
  from new_employee_hierarchy
)
SELECT * FROM new_employees