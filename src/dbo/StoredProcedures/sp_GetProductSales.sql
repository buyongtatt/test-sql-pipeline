--------------------------------------------------------------------------------
-- dbo.StoredProcedures.sp_GetProductSales.sql
-- NEW STORED PROCEDURE: total sales per product across all orders.
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[sp_GetProductSales]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.[ProductId],
        p.[ProductName],
        COUNT(i.[OrderItemId]) AS TimesOrdered,
        SUM(i.[Quantity])      AS TotalQuantitySold,
        SUM(i.[Quantity] * i.[UnitPrice]) AS TotalSalesAmount
    FROM [dbo].[Products] p
    LEFT JOIN [dbo].[OrderItems] i ON i.[ProductName] = p.[ProductName]
    GROUP BY p.[ProductId], p.[ProductName]
    ORDER BY TotalSalesAmount DESC;
END
GO

PRINT 'Created/altered procedure [dbo].[sp_GetProductSales].';
GO
