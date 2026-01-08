/*
1. Кількість працівників по відділам
*/
SELECT COUNT(*) AS employees_count, departmentName
FROM EmployeePositions
INNER JOIN Departments ON departmentID = Departments.id
WHERE positionStatus = 'current'
GROUP BY departmentName

/*
2. Заступники та відділи, що їм підпорядковуються
*/
SELECT PIB, STRING_AGG(departmentName, '; ') AS Departments
FROM
(
	SELECT CONCAT(employeeName, ' ', middlename, ' ', surname) AS PIB, departmentName
	FROM Departments
	INNER JOIN Managers ON managerID = Managers.id
	INNER JOIN Employees ON employeeID = Employees.id
) AS t
GROUP BY PIB

/*
3. Заступники, котрим підпорядковується більше одного відділу
*/
SELECT PIB
FROM
(
	SELECT CONCAT(employeeName, ' ', middlename, ' ', surname) AS PIB, departmentName
	FROM Departments
	INNER JOIN Managers ON managerID = Managers.id
	INNER JOIN Employees ON employeeID = Employees.id
) AS t
GROUP BY PIB
HAVING COUNT(departmentName) > 1

/*
4. Вивести ПІБ працівників категорії керівник
*/
SELECT CONCAT(employeeName, ' ', middlename, ' ', surname) AS PIB, category
FROM Employees
INNER JOIN EmployeePositions ON Employees.id = employeeID
INNER JOIN Positions ON positionID = Positions.id
WHERE category = 'kerivnyk'  AND positionStatus = 'current'

/*
5. Вивести загальну кількість неявок за січень 2023 року
*/
SELECT COUNT(*) AS total
FROM Timesheets
INNER JOIN TimeSpendings ON Timesheets.id = timesheetID
WHERE dateYear = 2023 AND dateMonth = 1 AND spendingType = 'H3'

/*
6. Вивести робітника першого відділу, котрий другий за кількість виготовлених виробів
*/
SELECT employeeID, total_products
FROM
(
	SELECT employeeID, total_products, ROW_NUMBER() OVER (ORDER BY total_products DESC) AS row_num 
	FROM 
	(
		SELECT Employees.id AS employeeID, SUM(productAmount) AS total_products
		FROM Departments
		INNER JOIN EmployeePositions ON Departments.id = departmentID
		INNER JOIN WorkAccounting ON EmployeePositions.id = WorkAccounting.employeePositionID
		INNER JOIN Employees ON EmployeePositions.employeeID = Employees.id
		WHERE departmentName = 'Department 1'  AND positionStatus = 'current'
		GROUP BY Employees.id
	) AS t
) AS tbl
WHERE row_num = 2

/*
7. Вивести робітників шостого розряду, які почали працювати або змінили посаду у 2024 році
*/
SELECT employeeName, surname, middlename, appointmentDate, workerCategory
FROM EmployeePositions
INNER JOIN WorkerCategories ON workerCategory = WorkerCategories.category
INNER JOIN Employees ON employeeID = Employees.id
WHERE workerCategory = 6 AND YEAR(appointmentDate) = 2024

/*
8. Вивести ПІБ директора підприємства
*/
SELECT employeeName, surname, middlename
FROM Positions
INNER JOIN EmployeePositions ON Positions.id = positionID
INNER JOIN Employees ON employeeID = Employees.id
WHERE positionName = 'CEO'  AND positionStatus = 'current'

/*
9. Вивести працівників, тривалість щорічної відпустки яких перевищує 55 днів
*/
SELECT employeeName, surname, middlename, annualLeave
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
WHERE annualLeave > 55  AND positionStatus = 'current'

/*
10. Вивести працівників що не мають жодної доплати та надбавки
*/
SELECT Employees.id
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
LEFT JOIN EmployeePositionsBonuses ON EmployeePositions.id = EmployeePositionsBonuses.employeePositionID
WHERE bonusID IS NULL AND positionStatus = 'current'
INTERSECT
SELECT Employees.id
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
LEFT JOIN EmployeePositionsAllowances ON EmployeePositions.id = EmployeePositionsAllowances.employeePositionID
WHERE allowanceID IS NULL AND positionStatus = 'current'

/*
11. Вивсети працівників, котрі не мають жодних неявок
*/
SELECT *
FROM Employees
WHERE id NOT IN
(
	SELECT DISTINCT Employees.id
	FROM Employees
	INNER JOIN EmployeePositions ON employeeID = Employees.id
	INNER JOIN Timesheets ON EmployeePositions.id = Timesheets.employeePositionID
	INNER JOIN TimeSpendings ON Timesheets.id = TimeSpendings.timesheetID
	WHERE spendingType = 'H3'
)

/*
12. Вивести загальну кількість службовців
*/
SELECT COUNT(*) AS total
FROM Positions
INNER JOIN EmployeePositions ON Positions.id = positionID
WHERE category = 'slujbovets' AND positionStatus = 'current'

/*
13. Для кожного виробу вивести, скільки разів його виготовили
*/
SELECT productName, SUM(productAmount) AS total_amount
FROM Products
INNER JOIN WorkAccounting ON Products.id = productID
GROUP BY productName

/*
14. Вивести працівників, відсортованих за тарифною ставкою в спадному порядку, та за тривалістю щорічної відпустки в зростаючому
*/
SELECT employeeName, surname, middlename, ROW_NUMBER() OVER (partition by departmentID order by wageRate DESC, annualLeave ASC) AS rank, wageRate, annualLeave
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
INNER JOIN Positions ON positionID = Positions.id
INNER JOIN Departments ON Departments.id = EmployeePositions.departmentID
WHERE positionStatus = 'current'
ORDER BY employeeName

/*
15. Вивести працівників, котрі мають більшу тарифну ставку ніж заступники, котрі ними керують
*/
SELECT employeeName, surname, middlename, E.wageRate AS wageRate
FROM 
(
	SELECT employeeName, surname, middlename, wageRate, departmentID
	FROM Employees
	INNER JOIN EmployeePositions ON employeeID = Employees.id
	INNER JOIN Positions ON positionID = Positions.id
	INNER JOIN Departments ON departmentID = Departments.id
	WHERE positionStatus = 'current'
) AS E
INNER JOIN 
(
	SELECT Managers.id as managerID, Departments.id AS departmentID, wageRate
	FROM Managers
	INNER JOIN Employees ON Managers.employeeID = Employees.id
	INNER JOIN EmployeePositions ON EmployeePositions.employeeID = Employees.id
	INNER JOIN Positions ON positionID = Positions.id
	INNER JOIN Departments ON Managers.id = managerID
	WHERE positionStatus = 'current'
) AS M ON E.departmentID = M.departmentID
WHERE E.wageRate > M.wageRate

/*
16. Вивести кількість документів для кожного працівника, який закінчив магістратуру
*/
SELECT Employees.id AS employeeID, COUNT(*) AS documents_count
FROM Employees
INNER JOIN Documents ON Employees.id = employeeID
WHERE education = 'master'
GROUP BY Employees.id

/*
17. Вивести всіх робітників, які працюють за погодинною формою оплати
*/
SELECT employeeName, surname, middlename, category, payment
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
INNER JOIN Positions ON positionID = Positions.id
WHERE category = 'robitnik' AND payment = 'vidryadna' AND positionStatus = 'current'

/*
18. Вивести працівників, які 12 лютого 2022 року працювали у третьому відділі
*/
SET STATISTICS TIME ON;

SELECT employeeName, middlename, surname, dateYear, dateDay, dateMonth, spendingType, departmentName
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
INNER JOIN Timesheets ON employeePositionID = EmployeePositions.id
INNER JOIN TimeSpendings ON timesheetID = Timesheets.id
INNER JOIN Departments ON departmentID = Departments.id
WHERE dateYear = 2022 AND dateMonth = 2 AND dateDay = 12 AND spendingType = 'P' AND departmentName = 'Department 3'

SET STATISTICS TIME OFF;

/*
19. Вивести висококваліфікованих працівників, які працюють у четвертому відділі
*/
SELECT employeeName, middlename, surname, qualification, departmentName
FROM Employees
INNER JOIN EmployeePositions ON employeeID = Employees.id
INNER JOIN Positions ON positionID = Positions.id
INNER JOIN Departments ON departmentID = Departments.id
WHERE qualification = 'high' AND departmentName = 'Department 4' AND positionStatus = 'current'

/*
20. Вивести працівників, котрі працювали більше ніж на двох посадах у підприємстві
*/
SELECT employeeName, middlename, surname, total_positions
FROM 
(
	SELECT employeeID, COUNT(*) AS total_positions
	FROM Employees
	INNER JOIN EmployeePositions ON employeeID = Employees.id
	GROUP BY employeeID
	HAVING COUNT(*) > 2
) AS t
INNER JOIN Employees ON employeeID = Employees.id
ORDER BY total_positions DESC

