/* Задача 1
   Добавил покрывающий индекс, убрал ORDER BY, т.к. сортировка уже производится при записи в индекс
   */


--DROP INDEX idx_SessionStart ON Marketing.WebLog

CREATE INDEX idx_SessionStart ON Marketing.WebLog (SessionStart ASC, ServerID ASC, SessionID, UserName)
DECLARE @StartTime datetime2 = '2010-08-30 16:27'
SELECT TOP (5000) wl.SessionID, wl.ServerID, wl.UserName
FROM Marketing.WebLog AS wl
WHERE wl.SessionStart >= @StartTime;

GO

/* Задача 2
   Добавил покрывающий индекс и убрал ORDER BY, как и в прошлой.
 */

--DROP INDEX idx_codes ON Marketing.PostalCode

CREATE INDEX idx_codes ON Marketing.PostalCode(StateCode ASC , PostalCode ASC ) INCLUDE (Country)
SELECT PostalCode, Country
FROM Marketing.PostalCode
WHERE StateCode = 'KY'

GO

/* Задача 3
   Добавил два индекса
 */

--DROP INDEX idx_prospect_ln ON Marketing.Prospect
--DROP INDEX idx_sales_ln ON Marketing.Salesperson

CREATE INDEX idx_prospect_ln ON Marketing.Prospect (LastName) INCLUDE (FirstName)

CREATE INDEX idx_sales_ln ON Marketing.Salesperson (LastName)

DECLARE @Counter INT = 0;
WHILE @Counter < 350
BEGIN
  SELECT p.LastName, p.FirstName
  FROM Marketing.Prospect AS p
  INNER JOIN Marketing.Salesperson AS sp
  ON p.LastName = sp.LastName
  ORDER BY p.LastName, p.FirstName;

  SELECT *
  FROM Marketing.Prospect AS p
  WHERE p.LastName = 'Smith';
  SET @Counter += 1;
END;

/* Задача 4
   Добавил три индекса
 */

--DROP INDEX idx_product ON Marketing.Product
--DROP INDEX idx_productModel ON Marketing.ProductModel
--DROP INDEX idx_subcategory ON Marketing.Subcategory

CREATE INDEX idx_product ON Marketing.Product (ProductID) INCLUDE (ProductModelID, SubcategoryID)
CREATE INDEX idx_productModel ON Marketing.ProductModel (ProductModelID) INCLUDE (ProductModel)
CREATE INDEX idx_subcategory ON Marketing.Subcategory (CategoryID) INCLUDE (SubcategoryName);

SET STATISTICS TIME ON;

SELECT
	c.CategoryName,
	sc.SubcategoryName,
	pm.ProductModel,
	COUNT(p.ProductID) AS ModelCount
FROM Marketing.ProductModel pm
	JOIN Marketing.Product p
		ON p.ProductModelID = pm.ProductModelID
	JOIN Marketing.Subcategory sc
		ON sc.SubcategoryID = p.SubcategoryID
	JOIN Marketing.Category c
		ON c.CategoryID = sc.CategoryID
GROUP BY c.CategoryName,
	sc.SubcategoryName,
	pm.ProductModel
HAVING COUNT(p.ProductID) > 1


SET STATISTICS TIME OFF;
