--------------------------------------------------------------------------------
-- dbo.Tables.OrderItems.sql
-- Idempotent: creates the OrderItems table only if it does not exist.
--------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[OrderItems]')
      AND type IN (N'U')
)
BEGIN
    CREATE TABLE [dbo].[OrderItems] (
        [OrderItemId] INT          IDENTITY(1,1) NOT NULL,
        [OrderId]     INT          NOT NULL,
        [ProductName] NVARCHAR(100) NOT NULL,
        [Quantity]    INT          NOT NULL CONSTRAINT [DF_OrderItems_Quantity] DEFAULT ((1)),
        [UnitPrice]   DECIMAL(10,2) NOT NULL,

        CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED ([OrderItemId] ASC),
        CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY ([OrderId])
            REFERENCES [dbo].[Orders] ([OrderId])
    );

    PRINT 'Created table [dbo].[OrderItems].';
END
ELSE
BEGIN
    PRINT 'Table [dbo].[OrderItems] already exists. Skipping.';
END
GO
