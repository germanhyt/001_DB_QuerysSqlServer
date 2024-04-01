

/********************************/
-- DAY 1
/********************************/

/**************/
-- TIPOS DE LENGUAJE SEGÚN SU FUNCIÓN:
-- DDL (Data Definition Lenguage | Lenguaje de Definición de datos):
--- CREATE, ALTER, DROP
-- DML (Data Manipulation Lenguage | Lenguaje de Manipulación de datos):
--- SELECT, INSERT, UPDATE, DELETE
-- DCL (Data Control Lenguage | Lenguaje de Control de datos):
--- GRANT, REVOKE, DENY
-- DQL (Data Query Lenguage | Lenguaje de Consulta de Datos)
--- SELECT
--- FROM + JOINS (INNER, LEFT, RIGHT, FULL OUTER, CROSS)
--- WHERE
--- GROUP BY
--- HAVING + "Filter inside grouping"
--- ORDER BY + ASC/DESC
--- LIMIT
-- TCL (Transaction Control Lenguage | Lenguje de Control Transaccional)
--- COMMIT
--- ROLLBACK
--- SAVEPOINT
--- SET TRANSACTION
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

DROP TABLE IF EXISTS MiprimeraTabla;
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

-- RIGHT JOIN - Conjunto de datos propios de la 2da tabla intersectada
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
-- DAY 4 (1ra práctica de los temas anteriores)
/********************************/

/**************/
-- 1) Crea 2 consultas; 1 que funcione y 1 que no funcione POR ORDEN LÓGICO, Solo hasta el GROUP BY  Usando TSQL 
/**************/
SELECT Products.CategoryID,
	COUNT(ProductID) 'Cantidad de productos'
FROM Products
GROUP BY CategoryID
GO

/**************/
-- 2) Se necesita tener una lista de códigos de productos mayores iguales a 60 y menores iguales  a 70 (USA TSQL – Tabla Products)
/**************/
SELECT ProductID AS 'Id-producto'
FROM Products
WHERE ProductID BETWEEN 60 AND 70
GO

/**************/
-- 3) Se necesita categorizar las ventas por la siguiente regla (USA TSQL, Tabla OrdersDetails): 
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
-- 4) Se necesita tener (USE Tables Orders,.OrdersDetails,.Customers y Products): 
-- • Una lista únicamente con las ventas realizadas por los siguientes campos: IdCliente,  NombreCliente, OrderID, NombreProducto, Venta 
-- NOTA: Solo mostrar ventas de clientes con código cuyo patrón de palabras comience con 'V' y ventas totales mayores iguales a 1000 
-- BONUS: Puedes agregar a la consulta información de la tabla Categories y  Supplier
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
-- 5) Necesitamos una lista de personas que no tengan registros nulos en el campo región de la Tabla Employees 
/**************/
SELECT CONCAT(FirstName,LastName) AS 'Nombre de Emoleado'
FROM Employees
WHERE Region IS NOT NULL
GO



/********************************/
-- DAY 5
/********************************/

/**************/
-- USE OF 'CASE'
/**************/

-- En una tabla definir el campo categoria y tener en cuenta lo siguiente usando el concepto CASE*:
-- • se necesita que los precios menores iguales a 8 contengan la palabra "Precio Bajo"
-- • precios mayores a 8 y menores iguales a 15 la palabra "Precio Medio"
-- • precios mayores a 15 y menores iguales a 45 la palabra "Medio Alto"
-- • precio mayores a 45 la palabra "Alto"
-- • en caso no tenga precio, la palabra "No tiene Precio"
SELECT
	ProductID AS 'ID producto',
	ProductName AS 'Nombre producto',
	UnitPrice AS 'Precio Unitario',
	CASE 
		WHEN UnitPrice<=8 
		 THEN 'Precio Bajo'
		WHEN UnitPrice>8 AND UnitPrice<=15 
 		 THEN 'Precio Medio' 
		WHEN UnitPrice>15 AND UnitPrice<=45 
 		 THEN 'Precio Medio Alto' 
		WHEN UnitPrice>=45 
 		 THEN 'Precio Alto' 
		ELSE 'No tiene Precio'  
	END AS Categoria
FROM Products
ORDER BY UnitPrice ASC
GO

/**************/
-- USE OF 'Subconsultas'
/**************/

/*******/
-- CORRELACIONADAS: A diferencia de una subconsulta normal, que se ejecuta una sola vez y devuelve un resultado, una subconsulta correlacionada se ejecuta múltiples veces, una vez por cada fila que está siendo evaluada en la consulta externa. Una subconsulta correlacional es aquella que está vinculada a la consulta externa. Se ejecuta una vez para cada fila seleccionada por la consulta externa. Se usa operadores Lógicos
/*******/

-- Hallar el pedido más reciente para cada cliente en la tabla Orders
SELECT CustomerID, OrderID, OrderDate
FROM Orders AS OUTORDERS
WHERE OrderDate=(
	SELECT MAX(OrderDate)
FROM Orders AS INERORDERS
WHERE OUTORDERS.CustomerID=INERORDERS.CustomerID
	)
ORDER BY CustomerID
GO

/*******/
-- ESCALAR: Una subconsulta escalar devuelve un único valor. Este tipo de subconsulta se puede utilizar en varias partes de la consulta principal, como el SELECT, WHERE o HAVING. Se usa Operadores Lógicos
/*******/

-- Se desea obtener el nro de orden, el número de producto, el precio unitario y la cantidad de la última orden generada
SELECT OrderID, ProductID, UnitPrice, Quantity
FROM [Order Details]
WHERE OrderID=(  --obtener la variable (que siempre cambia con el tiempo) de la última orden generada
	SELECT MAX(OrderID) AS 'Última Orden'
FROM Orders
	)
GO


/*******/
-- MÚLTIPLES VALORES: Este devuelve más de una columna o más de una fila, pero no una tabla completa. Se utilizan con operadores que pueden manejar múltiples valores como IN o con funciones que toman conjuntos de valores como argumento.
/*******/

-- Utilizar una subconsulta de múltiples valores para filtrar los resultados de la tabla Orders basados en cierta condición aplicada a la tabla Customers
SELECT CustomerID, OrderID
FROM Orders
WHERE CustomerID IN (
	SELECT CustomerID
FROM Customers
WHERE Customers.Country='Mexico'
)
GO


/*******/
-- Ejercicios
/*******/

-- Se requiere devolver los registro la tabla OrderDetails cuyo precio unitario sea mayor que todos los precios unitarios de los productos con el nombre 'Chocolade' en la tabla products. Luego ordenarios por la 3ra columna (precio unitario)
SELECT
	OD.OrderID AS 'ID Orden',
	OD.ProductID AS 'ID Product',
	OD.UnitPrice AS 'Precio Unitario'
FROM [Order Details] AS OD
WHERE OD.UnitPrice > ALL(  -- Sólo incluirá filas cuyo unitprice sea mayor que todos los precios unitarios que se obtuvieron de la subconsulta.
	SELECT DISTINCT OD2.UnitPrice
FROM [Order Details] AS OD2
	INNER JOIN Products AS P2
	ON OD2.ProductID=P2.ProductID
WHERE P2.ProductName='Chocolade'
)
ORDER BY 3 ASC
GO



/**************/
-- USE OF Set Operators
/**************/

-- UNION  // Une pero Elimina los duplicado
	SELECT City, Country, Region
	FROM Employees
UNION
	SELECT City, Country, Region
	FROM Customers
ORDER BY 1
GO

-- UNION ALL  // Une pero No Elimina los duplicados
	SELECT City, Country, Region
	FROM Employees
UNION ALL
	SELECT City, Country, Region
	FROM Customers
ORDER BY 1
GO

-- INTERSECT
	SELECT City, Country, Region
	FROM Employees
INTERSECT
	SELECT City, Country, Region
	FROM Customers
ORDER BY 1
GO

-- EXPCEPT
	SELECT City, Country, Region
	FROM Employees
EXCEPT
	SELECT City, Country, Region
	FROM Customers
ORDER BY 1
GO


/**************/
-- USE OF Vistas: Una vista es una tabla virtual que se compone de datos de una o más tablas reales en la base de datos. Las vistas permiten simplificar consultas complejas al predefinir cómo se deben unir y seleccionar los datos. Son útiles para presentar datos de manera organizada y restringir el acceso a ciertas columnas o filas. Las vistas no almacenan datos físicamente, sino que muestran los resultados de una consulta en tiempo real.
/**************/

-- CREAMOS LA VISTA
CREATE VIEW vw_primeravista
AS
	SELECT
		c.CustomerID as idCliente,
		c.ContactName as Cliente,
		o.OrderID as OrderId,
		p.ProductName as Producto,
		(odt.UnitPrice * odt.Quantity) as VentaTotal
	FROM DBO.Orders AS o
		INNER JOIN DBO.[Order Details] AS odt ON o.OrderID=odt.OrderID
		INNER JOIN DBO.Customers AS c ON o.CustomerID=c.CustomerID
		INNER JOIN DBO.Products AS p ON odt.ProductID= p.ProductID
GO

SELECT *
FROM vw_primeravista;
GO


-- MODIFICAMOS LA VISTA
ALTER VIEW vw_primeravista
AS
	SELECT
		c.CustomerID as id,
		c.ContactName as Cliente,
		o.OrderID as OrderId,
		p.ProductName as Producto,
		(odt.UnitPrice * odt.Quantity) as VentaTotal
	FROM DBO.Orders AS o
		INNER JOIN DBO.[Order Details] AS odt ON o.OrderID=odt.OrderID
		INNER JOIN DBO.Products AS p ON odt.ProductID= p.ProductID
		INNER JOIN DBO.Customers AS c ON o.CustomerID=c.CustomerID
GO
SELECT *
FROM vw_primeravista;
GO

-- ELIMINAMOS LA VISTA
-- DROP VIEW vw_primeravista;



/**************/
-- USE OF Functions: Una función es un bloque de código SQL que realiza una tarea específica y devuelve un valor o un conjunto de valores. Pueden ser funciones escalares que devuelven un solo valor o funciones tabulares que devuelven un conjunto de filas como resultado. Las funciones pueden aceptar parámetros y realizar operaciones complejas antes de devolver un resultado. Son útiles para reutilizar lógica en consultas, automatizar tareas y encapsular operaciones complejas.
/**************/

-- CREAR FUNCIONES
CREATE FUNCTION fn_primerafuncion (@orderid int)
RETURNS TABLE
AS 
	RETURN 
		SELECT
	c.CustomerID as idCliente,
	c.ContactName as Cliente,
	o.OrderID as OrderId,
	p.ProductName as Producto,
	(odt.UnitPrice * odt.Quantity) as VentaTotal
FROM DBO.Orders AS o
	INNER JOIN DBO.[Order Details] AS odt ON o.OrderID=odt.OrderID
	INNER JOIN DBO.Customers AS c ON o.CustomerID=c.CustomerID
	INNER JOIN DBO.Products AS p ON odt.ProductID= p.ProductID
where o.OrderID = @orderid
GO

-- SELECT *
-- FROM fn_primerafuncion(10248)
-- GO

-- MODIFICACIONES
ALTER FUNCTION fn_primerafuncion (@orderid int)
RETURNS TABLE
AS 
	RETURN 
		SELECT
	c.CustomerID as id,
	c.ContactName as Cliente,
	o.OrderID as OrderId,
	p.ProductName as Producto,
	(odt.UnitPrice * odt.Quantity) as VentaTotal
FROM DBO.Orders AS o
	INNER JOIN DBO.[Order Details] AS odt ON o.OrderID=odt.OrderID
	INNER JOIN DBO.Customers AS c ON o.CustomerID=c.CustomerID
	INNER JOIN DBO.Products AS p ON odt.ProductID= p.ProductID
where o.OrderID = @orderid
GO

-- SELECT *
-- FROM fn_primerafuncion(10248)
-- GO

/*El area de desarrollo necesita una function para consultas las ventas a 
traves del parametro: nombre del pais, crear lo solicitado que ayude a este
requerimiento. Usar las tablas ORDERS y CUSTOMERS asi mismo la funcion debe
devolver el ORDERID, ORDERDATE, CUSTID, CONTACTNAME*/
CREATE FUNCTION fn_consultaventas2(@pais VARCHAR(50))
RETURNS TABLE
AS 
	RETURN
	SELECT
	O.OrderID AS IdOrden,
	O.OrderDate AS FechaOrden,
	C.CustomerID AS IdCliente,
	C.ContactName AS Nombre,
	(odt.UnitPrice*odt.Quantity) as VentaTotal
FROM Orders AS O
	INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
	inner join [Order Details] AS ODT ON O.OrderID= ODT.OrderID
WHERE C.Country= @pais
GO

SELECT *
FROM fn_consultaventas2('Mexico');
GO


/**************/
-- USE OF Store Procedure(SP):  crea y ejecuta, en temas de performance el sp es mejor
/**************/

--CREAMOS
create procedure sp_store_procedure(@fech_ini date,
	@fech_fin date)
as
begin
	select *
	from dbo.Customers c
		inner join dbo.orders o on o.CustomerID=c.CustomerID
		inner join dbo.[Order Details] d on d.orderid=o.orderid
		inner join dbo.Products p on p.productid=d.productid
	where o.orderdate between @fech_fin and @fech_fin
end
go
-- select * from Orders;
-- exec sp_store_procedure @fech_ini='1996-07-04 00:00:00.000',@fech_fin='1997-08-27 00:00:00.000'
-- go

--MODIFICAMOS
alter procedure sp_store_procedure
as
	begin
	declare @custid VARCHAR(50)
	set @custid='HILAA'
	select c.CustomerID, c.companyname, o.orderdate, d.Quantity, d.unitprice, p.ProductName, (d.Quantity*d.unitprice) as total
	from dbo.Customers c
		inner join dbo.orders o on o.CustomerID=c.CustomerID
		inner join dbo.[Order Details] d on d.orderid=o.orderid
		inner join dbo.Products p on p.productid=d.productid
	where c.CustomerID=@custid
end
go
exec sp_store_procedure
go

--BORRAMOS
drop procedure sp_store_procedure





