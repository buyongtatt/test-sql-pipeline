--------------------------------------------------------------------------------
-- dbo.StoredProcedures.sp_GetCustomerOrders.sql
-- Returns all orders for a given customer, including order items.
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[sp_GetCustomerOrders]
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.[OrderId],
        o.[OrderDate],
        o.[TotalAmount],
        o.[Status],
        i.[OrderItemId],
        i.[ProductName],
        i.[Quantity],
        i.[UnitPrice]
    FROM [dbo].[Orders] o
    LEFT JOIN [dbo].[OrderItems] i ON i.[OrderId] = o.[OrderId]
    WHERE o.[CustomerId] = @CustomerId
    ORDER BY o.[OrderDate] DESC, i.[OrderItemId];
END
GO

PRINT 'Created/altered procedure [dbo].[sp_GetCustomerOrders].';
GO
