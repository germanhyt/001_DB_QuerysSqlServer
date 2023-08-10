	

/********************************/
-- DAY 1
/********************************/

/**************/
-- TIPOS DE LENGUAJE SEGÚN SU FUNCIÓN:
-- DML:
--- SELECT, INSERT, UPDATE, DELETE
-- DDL:
--- CREATE, ALTER, DROP
-- DCL:
--- GRANT, REVOKE, DENY
/**************/


-- El órden lógico con Select es: SELECT + FROM + WHERE
--WHERE(donde): Usado para filtrar en base a los valores de las columnas originales y se aplica antes de agrupar datos 
SELECT companyname,
		contactname,
		address,
		city 
FROM Customers;
GO

SELECT companyname AS 'Nombre compañia',
		contactname AS 'Nombre de contacto' 
FROM Customers WHERE city='London';
GO

CREATE TABLE MiprimeraTabla
(
		IdPersona int identity (1,1) primary key,
		DNI int,
		NombreCompleto Varchar(80),
		MesCumpleaños_numero char(3)
);
GO

SELECT * FROM MiprimeraTabla;
GO

INSERT INTO MiprimeraTabla
	VALUES (12345678, 'JUAN CARLOS', '3'),
	(12345678, 'SHEYLA LOURDES', '4'),
	(12345678,'jacquelyn Mantari', '12');
GO

SELECT * FROM MiprimeraTabla;
GO

UPDATE MiprimeraTabla
	 SET MesCumpleaños_numero = 'Dic'
	 where IdPersona = 2
 GO

DELETE FROM MiprimeraTabla
	 where IdPersona = 2
GO

SELECT * FROM MiprimeraTabla;
GO

ALTER TABLE MiprimeraTabla ADD Edad int
GO

ALTER TABLE MiprimeraTabla ALTER COLUMN EDAD INT
GO

UPDATE MiprimeraTabla
	set edad = 25
	where IdPersona >= 1
GO

SELECT * FROM MiprimeraTabla;
GO

/**************/
-- Elementos:              / Predicados u operadores:
-- Predicados              / ALL, ANY, BEETWEENN, IN, LIKE, OR, SOME
-- Operadores comparativos / =, >=, <=, <> 
-- Operadores lógicos      / AND, OR, NOT
-- Operadores matemáricos  / *, /, %, +, -
-- Concatenación           / +
/**************/

SELECT * FROM Products WHERE unitprice>10;
SELECT * FROM Products WHERE productid>=50 AND productid<=60;
SELECT * FROM Products WHERE productid  BETWEEN 50 AND 60;
GO

-- top
SELECT TOP  10 * FROM Customers;
-- Mostrar los 5 productos con mayor precio unitario
SELECT TOP 5 * FROM Products ORDER BY unitprice DESC;



/********************************/
-- DAY 2
/********************************/

-- Uso del Case, when y Else
SELECT
    CustomerID,
    CompanyName,
    Address,
    ContactName,
    Country,
    CASE
        WHEN country='USA' THEN '1'
        WHEN Country in ('GERMANY', 'FRANCE') THEN '2'
        ELSE '3'
    END AS Prioridad
 FROM Customers
 ORDER BY Customers.ContactName ASC;    



-- GROUP BY
SELECT Orders.EmployeeID AS 'ID Empleado', 
       COUNT(*) AS 'Cantidad de clientes' 
FROM Orders
WHERE Orders.CustomerID IN ('VINET','KOENE')
GROUP BY Orders.EmployeeID;

SELECT OrderID, 
       SUM(Quantity*UnitPrice-Discount) AS 'Total de ventas'
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderID DESC


--HAVING(Teniendo): Usado luego de agrupar datos, se aplica sobre los resultados de la agrupación que se hizo sobre los datos originales
SELECT Orders.EmployeeID AS 'ID Empleado',
      count(Orders.OrderID) as 'Cantidad de órdenes' 
FROM Orders 
GROUP BY Orders.EmployeeID
HAVING count(Orders.OrderID)>50
go

SELECT 
    Orders.CustomerID AS 'ID Cliente',
    COUNT(Orders.OrderID) AS 'Cantidad de órdenes'
FROM Orders
GROUP BY Orders.CustomerID
HAVING COUNT(Orders.OrderID)>1
GO


/**************/
-- Calcular en una nueva columna('VentasTotales') 
-- las VentasTotales, luego clasificar las ventas en otra 
-- columna('Categoria') en caso de ser > 500 
-- llamarlos 'ALTAS' caso contrario 'BAJAS',
-- usar la tabla Order Details
/**************/
SELECT orderid AS 'ID orden',
	   productid AS 'ID producto',
	   unitprice AS 'Precio unitario',
	   Quantity AS 'Cantidad',
	   unitprice*Quantity AS 'Total venta',
CASE
	WHEN unitprice*Quantity<500 THEN 'Ventas Bajas'
	ELSE 'Ventas Altas'
END AS 'Categoria Ventas'
FROM [Order Details];



/**************/
-- Calcular en una nueva columna('Costos Totales') 
-- las Costos Totales, luego clasificar los Costos en otra 
-- columna('Categoria') en caso de ser > 500 
-- llamarlos 'ALTOS' caso contrario 'BAJOS',
-- tener en cuenta que es necesario hacer un join
-- entre las tablas Products y Orders Details
/**************/
SELECT 
	PR.ProductID AS 'ID Producto',
	PR.ProductName AS 'Nombre del producto', 
	OD.UnitPrice AS 'Precio Unitario',
	OD.Quantity AS 'Cantidad',
	OD.UnitPrice*OD.Quantity AS 'Costo total',
CASE 
	WHEN OD.UnitPrice*OD.Quantity>500
	THEN 'Costo alto'
	ELSE 'Costo Bajo'
END AS 'Categoria Costo'
FROM Products AS PR
INNER JOIN [Order Details] AS OD
ON PR.ProductID=OD.ProductID;


SELECT 
    P.ProductID AS 'ID producto',
    P.ProductName AS 'Nombre producto',
    C.CategoryName AS 'Categoría producto',
    C.[Description] AS 'Descripción de Categoría' ,
    P.UnitPrice AS 'Precio de producto'
FROM Products AS P
INNER JOIN Categories AS C 
ON P.CategoryID=C.CategoryID


SELECT 
    CustomerID AS 'ID Cliente',
    CompanyName AS 'Nombre compañía',
    ContactName AS 'Nombre'
FROM Customers WHERE Customers.Country IS NOT NULL;


