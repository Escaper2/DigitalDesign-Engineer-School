/*
 * Запрос, выводящий имя сотрудника с максимальной заработной платой.
 */

SELECT id, name
FROM employee
ORDER BY salary DESC
LIMIT 1;

/*
 * Запрос, выводящий максимальную длину цепочки руководителей
 * по таблице сотрудников
 */

WITH RECURSIVE tree_traversal AS (
   SELECT id, 1 lvl
   FROM employee
   WHERE employee.chief_id IS NULL
   UNION ALL
   SELECT employee.id, lvl + 1
   FROM tree_traversal d, employee
   WHERE employee.chief_id = d.id
)
SELECT Max(lvl)
FROM  tree_traversal;

/*
 * Запрос, выводящий отдел с максимальной заработной платой сотрудников
 */

SELECT dep.id, dep.name
FROM department dep
JOIN employee empl on dep.id = empl.department_id
GROUP BY  dep.name, dep.id
ORDER BY sum(empl.salary) DESC
LIMIT 1;

/*
 * Запрос, выводящий сотрудника, чье имя начинается на "Р"
 * и заканчивается на "н"
 */

SELECT id, name
FROM employee
WHERE name LIKE 'Р%н';