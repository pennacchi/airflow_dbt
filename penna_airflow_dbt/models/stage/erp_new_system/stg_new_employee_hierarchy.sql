WITH RECURSIVE new_employee_hierarchy AS (
  -- Higher hierarchy employee (no one above them)
  SELECT
    employee_id,
    boss_id,
    e.name as employee_name,
    CAST(e.name AS STRING) as hierarchy_path,
    1 as hierarchy_level
  FROM
    {{ ref('stg_new_employees') }} e 
  WHERE boss_id IS NULL

  UNION ALL
  
  -- Get recursively the employees where each iteracion is one level below
  -- and we get the name of the employees creating a path from the higher hierarchy
  -- to the lower
  SELECT
    e.employee_id,
    e.boss_id,
    e.name as employee_name,
    eh.hierarchy_path || ' -> ' || e.name as hierarchy_path,
    eh.hierarchy_level + 1 as hierarchy_level 
  FROM
    {{ ref('stg_new_employees') }} e
  INNER JOIN
    new_employee_hierarchy eh ON e.boss_id = eh.employee_id
)
SELECT * FROM new_employee_hierarchy