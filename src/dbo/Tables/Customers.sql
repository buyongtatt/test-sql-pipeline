--------------------------------------------------------------------------------
-- dbo.Tables.Customers.sql
-- Idempotent: creates the Customers table only if it does not exist.
--------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Customers]')
      AND type IN (N'U')
)
BEGIN
    CREATE TABLE [dbo].[Customers] (
        [CustomerId]   INT           IDENTITY(1,1) NOT NULL,
        [FirstName]    NVARCHAR(50)  NOT NULL,
        [LastName]     NVARCHAR(50)  NOT NULL,
        [Email]        NVARCHAR(100) NOT NULL,
        [Phone]        NVARCHAR(20)  NULL,
        [CreatedDate]  DATETIME2     NOT NULL CONSTRAINT [DF_Customers_CreatedDate] DEFAULT (SYSDATETIME()),
        [IsActive]     BIT           NOT NULL CONSTRAINT [DF_Customers_IsActive] DEFAULT ((1)),

        CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerId] ASC),
        CONSTRAINT [UQ_Customers_Email] UNIQUE NONCLUSTERED ([Email])
    );

    PRINT 'Created table [dbo].[Customers].';
END
ELSE
BEGIN
    PRINT 'Table [dbo].[Customers] already exists. Skipping.';
END
GO

--------------------------------------------------------------------------------
-- Add Address column if missing (safe to re-run).
--------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[Customers]')
      AND name = N'Address'
)
BEGIN
    ALTER TABLE [dbo].[Customers] ADD [Address] NVARCHAR(200) NULL;
    PRINT 'Added column [Address] to [dbo].[Customers].';
END
ELSE
BEGIN
    PRINT 'Column [Address] already exists on [dbo].[Customers]. Skipping.';
END
GO
