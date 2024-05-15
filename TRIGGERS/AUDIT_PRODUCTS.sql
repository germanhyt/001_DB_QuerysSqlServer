CREATE TRIGGER tr_productTablesAudit
ON Products
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- SQL Server, inserted es una tabla especial que se utiliza dentro de los triggers. No es una tabla física que puedas ver en tu base de datos. En su lugar, SQL Server la proporciona para su uso durante la ejecución de triggers.
    -- La tabla inserted contiene los nuevos datos para las operaciones INSERT y UPDATE. Para una operación INSERT, contiene la nueva fila que se está insertando. Para una operación UPDATE, contiene los nuevos valores de la fila que se está actualizando.
    -- En tu trigger, estás utilizando correctamente la tabla inserted para capturar los cambios que se están realizando en la tabla Products. Cuando se inserta o actualiza una fila en la tabla Products, tu trigger insertará una fila en la tabla AuditLog con los detalles del cambio.
    IF (SELECT COUNT(*)
    FROM inserted) > 0
    BEGIN
        INSERT INTO AuditLog
            (TableName, AuditAction, AuditDate, ProductID, ProductName)
        SELECT 'Products', 'INSERT', GETDATE(), ProductID, ProductName
        FROM inserted;
    END

    IF (SELECT COUNT(*)
    FROM deleted) > 0
    BEGIN
        INSERT INTO AuditLog
            (TableName, AuditAction, AuditDate, ProductID, ProductName)
        SELECT 'Products', 'DELETE', GETDATE(), ProductID, ProductName
        FROM deleted;
    END

    IF (SELECT COUNT(*)
        FROM inserted) > 0 AND (SELECT COUNT(*)
        FROM deleted) > 0
    BEGIN
        INSERT INTO AuditLog
            (TableName, AuditAction, AuditDate, ProductID, ProductName)
        SELECT 'Products', 'UPDATE', GETDATE(), ProductID, ProductName
        FROM inserted;
    END

END;


-- ALTER TABLE Products ENABLE TRIGGER tr_productTablesAudit;
-- DROP TRIGGER Products_Audit;

-- permissions trigger Products_Audit
GRANT ALTER ON Products_Audit TO public;
GRANT EXECUTE ON Products_Audit TO public;
DENY EXECUTE ON Products_Audit TO public;


-- CREATE TABLE AuditLog
-- (
--     AuditLogID int IDENTITY(1,1) PRIMARY KEY,
--     TableName nvarchar(128),
--     AuditAction nvarchar(50),
--     AuditDate datetime,
--     ProductID int,
--     ProductName nvarchar(40)
-- -- );
SELECT *
FROM AuditLog



SELECT *
FROM Products

UPDATE Products
SET SupplierID = 1
WHERE ProductID = 1