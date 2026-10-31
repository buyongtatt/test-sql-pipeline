--------------------------------------------------------------------------------
-- dbo.Tables.Products.sql
-- NEW TABLE: Product catalog.
-- Idempotent: creates the Products table only if it does not exist.
--------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Products]')
      AND type IN (N'U')
)
BEGIN
    CREATE TABLE [dbo].[Products] (
        [ProductId]   INT           IDENTITY(1,1) NOT NULL,
        [ProductName] NVARCHAR(100) NOT NULL,
        [Price]       DECIMAL(10,2) NOT NULL CONSTRAINT [DF_Products_Price] DEFAULT ((0.00)),
        [IsActive]    BIT           NOT NULL CONSTRAINT [DF_Products_IsActive] DEFAULT ((1)),
        [CreatedDate] DATETIME2     NOT NULL CONSTRAINT [DF_Products_CreatedDate] DEFAULT (SYSDATETIME()),

        CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductId] ASC),
        CONSTRAINT [UQ_Products_ProductName] UNIQUE NONCLUSTERED ([ProductName])
    );

    PRINT 'Created table [dbo].[Products].';
END
ELSE
BEGIN
    PRINT 'Table [dbo].[Products] already exists. Skipping.';
END
GO
