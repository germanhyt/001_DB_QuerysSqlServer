

CREATE TRIGGER Prevent_Order_Deletion
ON Orders
FOR DELETE
AS
BEGIN
    PRINT 'You cannot delete orders.';
    ROLLBACK;
END;