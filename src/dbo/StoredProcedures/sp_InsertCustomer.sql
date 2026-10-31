--------------------------------------------------------------------------------
-- dbo.StoredProcedures.sp_InsertCustomer.sql
-- Inserts a new customer and returns the generated CustomerId.
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[sp_InsertCustomer]
    @FirstName  NVARCHAR(50),
    @LastName   NVARCHAR(50),
    @Email      NVARCHAR(100),
    @Phone      NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[Customers] ([FirstName], [LastName], [Email], [Phone])
    VALUES (@FirstName, @LastName, @Email, @Phone);

    SELECT SCOPE_IDENTITY() AS NewCustomerId;
END
GO

PRINT 'Created/altered procedure [dbo].[sp_InsertCustomer].';
GO
