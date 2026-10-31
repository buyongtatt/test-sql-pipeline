--------------------------------------------------------------------------------
-- dbo.Tables.Orders.sql
-- Idempotent: creates the Orders table only if it does not exist.
--------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Orders]')
      AND type IN (N'U')
)
BEGIN
    CREATE TABLE [dbo].[Orders] (
        [OrderId]     INT          IDENTITY(1,1) NOT NULL,
        [CustomerId]  INT          NOT NULL,
        [OrderDate]   DATETIME2    NOT NULL CONSTRAINT [DF_Orders_OrderDate] DEFAULT (SYSDATETIME()),
        [TotalAmount] DECIMAL(10,2) NOT NULL CONSTRAINT [DF_Orders_TotalAmount] DEFAULT ((0.00)),
        [Status]      NVARCHAR(20) NOT NULL CONSTRAINT [DF_Orders_Status] DEFAULT (N'Pending'),

        CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderId] ASC),
        CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerId])
            REFERENCES [dbo].[Customers] ([CustomerId])
    );

    PRINT 'Created table [dbo].[Orders].';
END
ELSE
BEGIN
    PRINT 'Table [dbo].[Orders] already exists. Skipping.';
END
GO
