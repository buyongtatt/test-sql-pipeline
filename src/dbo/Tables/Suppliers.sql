--------------------------------------------------------------------------------
-- dbo.Tables.Suppliers.sql
-- NEW TABLE: Supplier master data.
-- Idempotent: creates the Suppliers table only if it does not exist.
--------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Suppliers]')
      AND type IN (N'U')
)
BEGIN
    CREATE TABLE [dbo].[Suppliers] (
        [SupplierId]   INT           IDENTITY(1,1) NOT NULL,
        [SupplierName] NVARCHAR(100) NOT NULL,
        [ContactName]  NVARCHAR(100) NULL,
        [Phone]        NVARCHAR(20)  NULL,
        [Email]        NVARCHAR(100) NULL,
        [IsActive]     BIT           NOT NULL CONSTRAINT [DF_Suppliers_IsActive] DEFAULT ((1)),
        [CreatedDate]  DATETIME2     NOT NULL CONSTRAINT [DF_Suppliers_CreatedDate] DEFAULT (SYSDATETIME()),

        CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([SupplierId] ASC),
        CONSTRAINT [UQ_Suppliers_SupplierName] UNIQUE NONCLUSTERED ([SupplierName])
    );

    PRINT 'Created table [dbo].[Suppliers].';
END
ELSE
BEGIN
    PRINT 'Table [dbo].[Suppliers] already exists. Skipping.';
END
GO
