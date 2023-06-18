/* 2*/

SELECT YEAR(OrderDate)  AS SalesYear,
       MONTH(OrderDate) AS SalesMonth,
       SUM(TotalDue)    AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate),
         MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;

/* 3*/

SELECT TOP 10 City AS City, COUNT(DISTINCT BusinessEntityID) AS Priority
FROM Sales.vIndividualCustomer
WHERE City NOT IN (SELECT City FROM Sales.vStoreWithAddresses)
GROUP BY City
ORDER BY COUNT(DISTINCT BusinessEntityID) DESC;

/* 4*/

SELECT person.LastName      AS Surname,
       person.FirstName     AS Name,
       product.Name         AS ProductName,
       SUM(detail.OrderQty) AS Quantity
FROM Sales.SalesOrderHeader AS header
         JOIN Sales.SalesOrderDetail AS detail ON header.SalesOrderId = detail.SalesOrderId
         JOIN Sales.Customer AS customer ON header.CustomerId = customer.CustomerId
         JOIN Person.Person AS person ON customer.PersonId = person.BusinessEntityID
         JOIN Production.Product AS product ON detail.ProductId = product.ProductId
GROUP BY person.LastName,
         person.FirstName,
         product.Name
HAVING SUM(detail.OrderQty) > 15
ORDER BY Quantity DESC,
         person.LastName,
         person.FirstName;

/* 5*/

SELECT sales.OrderDate,
       person.LastName,
       person.FirstName,
       STRING_AGG(CONCAT(Product.Name, N' Количество: ', detail.OrderQty, N' шт.'),
                  CHAR(10)) as 'Product'
FROM Sales.SalesOrderHeader as sales
         JOIN Sales.Customer as customer on sales.CustomerID = customer.CustomerID
         JOIN Person.Person as person on customer.PersonID = person.BusinessEntityID
         JOIN Sales.SalesOrderDetail as detail on sales.SalesOrderID = detail.SalesOrderID
         JOIN Production.Product as product on detail.ProductID = product.ProductID
WHERE sales.OrderDate = (SELECT MIN(ord.OrderDate)
                         FROM Sales.SalesOrderHeader as ord
                         WHERE ord.CustomerID = sales.CustomerID)
GROUP BY sales.OrderDate,
         person.LastName,
         Person.FirstName
ORDER BY sales.OrderDate DESC;

/* 6*/

SELECT CONCAT(person.LastName, ' ', left(person.FirstName, 1), '.', left(person.MiddleName, 1)) AS ChiefName,
       employee.HireDate                                                                        AS ChiefHireDate,
       employee.BirthDate                                                                       AS ChiefBirthDate,
       CONCAT(secPerson.LastName, ' ', left(secPerson.FirstName, 1), '.',
              left(secPerson.MiddleName, 1))                                                    AS EmployeeName,
       secEmployee.HireDate                                                                     AS EmployeeHireDate,
       secEmployee.BirthDate                                                                    AS EmployeeBimthDate
FROM HumanResources.Employee AS employee
         JOIN HumanResources.Employee as secEmployee
              on secEmployee.OrganizationNode.GetAncestor(1) = employee.OrganizationNode
         JOIN Person.Person as person on employee.BusinessEntityID = person.BusinessEntityID
         JOIN Person.Person as secPerson on secEmployee.BusinessEntityID = secPerson.BusinessEntityID
WHERE employee.BirthDate > secEmployee.BirthDate
  AND employee.HireDate > secEmployee.HireDate
ORDER BY employee.OrganizationNode, secPerson.LastName, secPerson.FirstName, len(employee.OrganizationNode.ToString());

/* 7*/

CREATE PROCEDURE HumanResources.Bachelor(
    @TimeStart date,
    @TimeEnd date,
    @CountFoundEmployees int OUTPUT
)
AS
BEGIN
    SELECT *
    FROM HumanResources.Employee
    WHERE Gender = 'M'
      and MaritalStatus = 'S'
      and BirthDate >= @TimeStart
      and BirthDate <= @TimeEnd

    SELECT @CountFoundEmployees = COUNT(*)
    FROM HumanResources.Employee
    WHERE Gender = 'M'
      and MaritalStatus = 'S'
      and BirthDate >= @TimeStart
      and BirthDate <= @TimeEnd
END

DECLARE @total INT
DECLARE @a date
DECLARE @b date
SELECT @a = PARSE('01.01.1969' as date)
SELECT @b = PARSE('01.01.2000' as date)
    EXEC HumanResources.Bachelor @a, @b, @total output
SELECT @total
    DROP PROCEDURE HumanResources.Bachelor;