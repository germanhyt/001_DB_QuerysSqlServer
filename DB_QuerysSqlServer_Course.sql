

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


SELECT companyname AS 'Nombre compañia',
	contactname AS 'Nombre de contacto'
FROM Customers
WHERE city='London';
GO

CREATE TABLE MiprimeraTabla
(
	IdPersona int identity (1,1) primary key,
	DNI int,
	NombreCompleto Varchar(80),
	MesCumpleaños_numero char(3)
);
GO

SELECT *
FROM MiprimeraTabla;
GO

INSERT INTO MiprimeraTabla
VALUES
	(12345678, 'JUAN CARLOS', '3'),
	(12345678, 'SHEYLA LOURDES', '4'),
	(12345678, 'jacquelyn Mantari', '12');
GO

SELECT *
FROM MiprimeraTabla;
GO

UPDATE MiprimeraTabla
	 SET MesCumpleaños_numero = 'Dic'
	 where IdPersona = 2
 GO

DELETE FROM MiprimeraTabla
	 where IdPersona = 2
GO

SELECT *
FROM MiprimeraTabla;
GO

ALTER TABLE MiprimeraTabla ADD Edad int
GO

ALTER TABLE MiprimeraTabla ALTER COLUMN EDAD INT
GO

UPDATE MiprimeraTabla
	set edad = 25
	where IdPersona >= 1
GO

SELECT *
FROM MiprimeraTabla;
GO

/**************/
-- Elementos:              / Predicados u operadores:
-- Predicados              / ALL, ANY, BEETWEENN, IN, LIKE, OR, SOME
-- Operadores comparativos / =, >=, <=, <> 
-- Operadores lógicos      / AND, OR, NOT
-- Operadores matemáricos  / *, /, %, +, -
-- Concatenación           / +
/**************/

SELECT *
FROM Products
WHERE unitprice>10;
SELECT *
FROM Products
WHERE productid>=50 AND productid<=60;
SELECT *
FROM Products
WHERE productid  BETWEEN 50 AND 60;
GO

-- top
SELECT TOP  10
	*
FROM Customers;
-- Mostrar los 5 productos con mayor precio unitario
SELECT TOP 5
	*
FROM Products
ORDER BY unitprice DESC;

-- LIKE:  En SQL Server se utiliza para buscar un patrón específico en una columna. Se utiliza a menudo en combinación con la instrucción SELECT para encontrar registros que coincidan con un patrón determinado.
-- • %: El símbolo de porcentaje representa cero, uno o varios caracteres. Por ejemplo, LIKE 'a%' buscará cualquier valor que comience con "a".
-- • _: El guion bajo representa un solo carácter. Por ejemplo, LIKE 'a_' buscará cualquier valor que tenga "a" como primer carácter y exactamente un carácter adicional.
SELECT ProductId, ProductName
FROM Products
WHERE ProductName LIKE '%a%';


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

/*** Orden de query *******/
-- SELECT 
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY
/**************/
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
GO


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
GO

SELECT
	P.ProductID AS 'ID producto',
	P.ProductName AS 'Nombre producto',
	C.CategoryName AS 'Categoría producto',
	C.[Description] AS 'Descripción de Categoría' ,
	P.UnitPrice AS 'Precio de producto'
FROM Products AS P
	INNER JOIN Categories AS C
	ON P.CategoryID=C.CategoryID
GO

-- INNER JOIN - Intersección
SELECT
	CustomerID AS 'ID Cliente',
	CompanyName AS 'Nombre compañía',
	ContactName AS 'Nombre'
FROM Customers
WHERE Customers.Country IS NOT NULL;
GO

-- LEFT JOIN - Conjunto de datos propios de la 1ra tabla 
SELECT
	O.OrderID AS 'ID orden',
	O.OrderDate AS 'Fecha de Orden',
	C.CustomerID AS 'ID cliente',
	c.CompanyName AS 'Compañía de Cliente',
	c.Country AS 'Procedencia de Cliente'
FROM Orders as O
	LEFT JOIN Customers AS C
	ON O.CustomerID=C.CustomerID;
GO

-- LEFT JOIN - Conjunto de datos propios de la 2da tabla intersectada
SELECT
	O.OrderID AS 'ID orden',
	O.OrderDate AS 'Fecha de Orden',
	C.CustomerID AS 'ID cliente',
	c.CompanyName AS 'Compañía de Cliente',
	c.Country AS 'Procedencia de Cliente'
FROM Orders as O
	RIGHT JOIN Customers AS C
	ON O.CustomerID=C.CustomerID;
GO

-- FULL JOIN - Conjunto de datos propios de ambas tablas más la intersección
SELECT
	O.OrderID AS 'ID orden',
	O.OrderDate AS 'Fecha de Orden',
	C.CustomerID AS 'ID cliente',
	c.CompanyName AS 'Compañía de Cliente',
	c.Country AS 'Procedencia de Cliente'
FROM Orders as O
	FULL JOIN Customers AS C
	ON O.CustomerID=C.CustomerID;
GO

-- SELF JOIN - Conjunto de datos de la misma tabla, se usa inner join
SELECT *
FROM Employees;
SELECT
	X.EmployeeID,
	CONCAT(X.LastName,' ', X.FirstName,' - ', X.Title) AS 'Jefe',
	Y.LastName+' '+Y.FirstName+' - '+ Y.Title AS 'Empleado'
FROM Employees AS X
	INNER JOIN Employees AS Y
	ON X.EmployeeID=Y.EmployeeID
ORDER BY 1;
GO


/********************************/
-- DAY 3
/********************************/

/**************/
-- Funciones de Agregación
-- COUNT - Nos permite contabilizar filas sin contabilizar los nulls 
-- SUM - Suma de números
-- AVG - Promedio de números
-- MIN y MAX - Número mín y máx de un conjunto de números
/**************/
SELECT COUNT(*) AS 'Cantidad de Clientes'
FROM Customers;
GO
SELECT COUNT(CustomerID) AS 'Cantidad de Clientes'
FROM Customers;
GO
SELECT COUNT(Region) AS 'Cantidad de Clientes con región'
FROM Customers;
GO
SELECT COUNT(DISTINCT City) AS 'Cantidad de ciudades únicas de la tabla Clientes'
FROM Customers;
GO
SELECT COUNT(DISTINCT Region) AS 'Cantidad de paises únicos de la tabla Clientes'
FROM Customers;
GO

SELECT SUM(quantity) AS 'Cantidad de productos en total'
FROM [Order Details];
GO
SELECT SUM(UnitPrice) AS 'Costo total de productos'
FROM [Order Details];
GO

SELECT AVG(quantity) AS 'Promedio de cantidad de productos'
FROM [Order Details];
GO
SELECT AVG(UnitPrice*Quantity) AS 'Promedio de ventas de pedidos'
FROM [Order Details];
GO

SELECT MIN(quantity) AS 'Mínimo de cantidad de productos'
FROM [Order Details];
GO
SELECT MAX(UnitPrice*Quantity) AS 'Máximo de ventas de pedidos'
FROM [Order Details];
GO


/**************/
-- 1) Determinar El total de ventas, ordenado por su correlativo en la tabla orderDetails).
/**************/
SELECT
	OrderID,
	SUM(Quantity*UnitPrice-Discount) AS 'Total de ventas'
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderID DESC;
GO

/**************/
-- 2) El numero (conteo) de ordenes mayores a 100, con su correlativo de la tabla orders, agrupar pedidos por empleado
/**************/
SELECT
	Orders.EmployeeID AS 'ID Empleado',
	COUNT(*) AS 'Cantidad de pedidos mayores a 100 por empleado'
FROM Orders
GROUP BY Orders.EmployeeID
HAVING COUNT(OrderID)>100;
GO

/**************/
-- 3) El total de ciudades (no repetivas), de la cual su region no sea nulo de la tabla Sales.Customers.
/**************/
SELECT COUNT(DISTINCT City) AS 'Número de ciudades no Repetitivas'
fROM Customers
WHERE Region IS NOT NULL;
GO

/**************/
-- EL nombre de empleados (NOMBRE COMPLETO), de los cuales su region sea nulo de la tabla HR.Employees
/**************/
SELECT CONCAT(FirstName,' ', LastName) AS 'Nombre de Empleado',
	Title AS 'Ocupación'
FROM Employees
WHERE Region IS NULL;
GO

/********************************/
-- DAY 4
/********************************/

/**************/
-- 1ra práctica de los temas anteriores
/**************/

/**************/
-- 1) Crea 2 consultas; 1 que funcione y 1 que no funcione POR ORDEN LÓGICO, Solo hasta el GROUP BY  Usando TSQL 
/**************/
SELECT Products.CategoryID,
	COUNT(ProductID) 'Cantidad de productos'
FROM Products
GROUP BY CategoryID
GO

/**************/
-- 2) Se necesita tener una lista de códigos de productos mayores iguales a 60 y menores iguales  a 70 (USA TSQL – Production.Products)
/**************/
SELECT ProductID AS 'Id-producto'
FROM Products
WHERE ProductID BETWEEN 60 AND 70
GO

/**************/
-- 3) Se necesita categorizar las ventas por la siguiente regla (USA TSQL; Sales.OrdersDetails): 
-- • Ventas Totales Mayores iguales a 500 – “ALTAS” 
-- • Ventas Totales Menores a 500 – “BAJAS” 
/**************/
SELECT orderID AS 'Id-Orden',
	ProductID as 'Id-producto',
	UnitPrice AS 'Precio',
	Quantity AS 'Cantidad',
	UnitPrice*Quantity AS 'Ventas totales',
	CASE
		WHEN UnitPrice*Quantity<500 THEN 'Bajas'
		ELSE 'Altas'
	END AS 'Categoria de Venta'
FROM [Order Details]
GO

/**************/
-- 4) Se necesita tener (USE TSQL Sales.Orders, Sales.OrdersDetails, Sales.Customers y  Production.Products): 
-- • Una lista únicamente con las ventas realizadas por los siguientes campos: IdCliente,  NombreCliente, OrderID, NombreProducto, Venta 
-- NOTA: Solo mostrar ventas de clientes con código cuyo patrón de palabras comience con 'V' y ventas totales mayores iguales a 1000 
-- BONUS: Puedes agregar a la consulta información de la tabla Production.Categories y  Production.Supplier
/**************/
SELECT
	O.CustomerID AS 'Id-cliente',
	CU.ContactName as 'Nombre de Cliente',
	O.OrderID AS 'Id-Orden',
	P.ProductName AS 'Producto',
	S.CompanyName AS 'Proveedor',
	OD.UnitPrice*OD.Quantity AS 'Venta total'
FROM Orders AS O
	INNER JOIN Customers AS CU ON CU.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD ON OD.OrderID=O.OrderID
	INNER JOIN Products AS P ON P.ProductID=OD.ProductID
	INNER JOIN Categories AS CA ON CA.CategoryID=P.CategoryID
	INNER JOIN Suppliers AS S ON S.SupplierID=P.SupplierID
WHERE CU.CustomerID LIKE 'V%' AND OD.UnitPrice*OD.Quantity>=1000
GO

/**************/
-- 5) Necesitamos una lista de personas que no tengan registros nulos en el campo región de la  Tabla HR.Employees 
/**************/
SELECT CONCAT(FirstName,LastName) AS 'Nombre de Emoleado'
FROM Employees
WHERE Region IS NOT NULL
GO

