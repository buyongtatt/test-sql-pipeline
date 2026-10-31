--------------------------------------------------------------------------------
-- dbo.StoredProcedures.sp_GetSupplierOrders.sql
-- NEW STORED PROCEDURE: orders grouped by supplier (via product name match).
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[sp_GetSupplierOrders]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        s.[SupplierId],
        s.[SupplierName],
        s.[ContactName],
        COUNT(DISTINCT o.[OrderId]) AS OrderCount,
        SUM(i.[Quantity])           AS TotalItemsSold,
        SUM(i.[Quantity] * i.[UnitPrice]) AS TotalSalesAmount
    FROM [dbo].[Suppliers] s
    LEFT JOIN [dbo].[OrderItems] i ON i.[ProductName] = s.[SupplierName]
    LEFT JOIN [dbo].[Orders] o ON o.[OrderId] = i.[OrderId]
    GROUP BY s.[SupplierId], s.[SupplierName], s.[ContactName]
    ORDER BY TotalSalesAmount DESC;
END
GO

PRINT 'Created/altered procedure [dbo].[sp_GetSupplierOrders].';
GO
