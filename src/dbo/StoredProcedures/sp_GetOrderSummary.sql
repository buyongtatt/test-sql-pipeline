--------------------------------------------------------------------------------
-- dbo.StoredProcedures.sp_GetOrderSummary.sql
-- Returns a summary of all orders with customer names and item counts.
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[sp_GetOrderSummary]
    @MinOrderDate DATE = NULL   -- optional: only include orders on/after this date
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.[OrderId],
        c.[FirstName] + ' ' + c.[LastName] AS CustomerName,
        o.[OrderDate],
        o.[Status],
        o.[TotalAmount],
        COUNT(i.[OrderItemId]) AS ItemCount
    FROM [dbo].[Orders] o
    INNER JOIN [dbo].[Customers] c ON c.[CustomerId] = o.[CustomerId]
    LEFT JOIN [dbo].[OrderItems] i ON i.[OrderId] = o.[OrderId]
    WHERE (@MinOrderDate IS NULL OR o.[OrderDate] >= @MinOrderDate)
    GROUP BY
        o.[OrderId], c.[FirstName], c.[LastName], o.[OrderDate], o.[Status], o.[TotalAmount]
    ORDER BY o.[OrderDate] DESC;
END
GO

PRINT 'Created/altered procedure [dbo].[sp_GetOrderSummary].';
GO
