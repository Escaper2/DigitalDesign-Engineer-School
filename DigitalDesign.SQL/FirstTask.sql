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
       concat('Product Name: ', product.Name, '   ', 'Quantity: ', detail.OrderQty) as 'Product'
FROM Sales.SalesOrderHeader as sales
         JOIN Sales.Customer as customer on sales.CustomerID = customer.CustomerID
         JOIN Person.Person as person on customer.PersonID = person.BusinessEntityID
         JOIN Sales.SalesOrderDetail as detail on sales.SalesOrderID = detail.SalesOrderDetailID
         JOIN Production.Product as product on detail.ProductID = product.ProductID
WHERE sales.OrderDate = (SELECT MIN(ord.OrderDate)
                         FROM Sales.SalesOrderHeader as ord
                         WHERE ord.CustomerID = sales.CustomerID)
ORDER BY sales.OrderDate

/* 7*/

CREATE PROCEDURE HumanResources.Bachelor(
    @TimeStart date,
    @TimeEnd date,
    @CountFoundEmployees int OUTPUT
)
AS
BEGIN
    SELECT @CountFoundEmployees = COUNT(Employee.BusinessEntityID)
    FROM HumanResources.Employee
    WHERE Employee.Gender = 'M'
      AND Employee.MaritalStatus = 'S'
      AND Employee.BirthDate >= @TimeStart
      AND Employee.BirthDate <= @TimeEnd
    SELECT Employee.BusinessEntityID,
           Employee.NationalIDNumber,
           Employee.LoginID,
           Employee.OrganizationNode,
           Employee.OrganizationLevel,
           Employee.JobTitle,
           Employee.BirthDate,
           Employee.MaritalStatus,
           Employee.Gender,
           Employee.HireDate,
           Employee.SalariedFlag,
           Employee.VacationHours,
           Employee.SickLeaveHours,
           Employee.CurrentFlag,
           Employee.rowguid,
           Employee.ModifiedDate
    FROM HumanResources.Employee
    WHERE Employee.Gender = 'M'
      AND Employee.MaritalStatus = 'S'
      AND Employee.BirthDate >= @TimeStart
      AND Employee.BirthDate <= @TimeEnd
    GROUP BY Employee.BusinessEntityID, Employee.NationalIDNumber, Employee.LoginID,
             Employee.OrganizationNode, Employee.OrganizationLevel, Employee.JobTitle, Employee.BirthDate,
             Employee.MaritalStatus, Employee.Gender, Employee.HireDate,
             Employee.SalariedFlag, Employee.VacationHours, Employee.SickLeaveHours, Employee.CurrentFlag,
             Employee.rowguid, Employee.ModifiedDate;
END;