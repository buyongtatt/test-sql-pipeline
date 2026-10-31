--------------------------------------------------------------------------------
-- deploy.sql
-- Master deployment script.
-- Executes all database objects in dependency order.
--
-- Usage (sqlcmd):
--   sqlcmd -S localhost -E -d master -i ".\src\deploy.sql"
--------------------------------------------------------------------------------
:on error exit

--------------------------------------------------------------------------------
-- 1. Create the database (if missing)
--------------------------------------------------------------------------------
:r .\01_CreateDatabase.sql

--------------------------------------------------------------------------------
-- 2. Tables (dependency order: Customers -> Orders -> OrderItems)
--------------------------------------------------------------------------------
:r .\dbo\Tables\Customers.sql
:r .\dbo\Tables\Orders.sql
:r .\dbo\Tables\OrderItems.sql
:r .\dbo\Tables\Products.sql

--------------------------------------------------------------------------------
-- 3. Stored procedures
--------------------------------------------------------------------------------
:r .\dbo\StoredProcedures\sp_GetCustomerOrders.sql
:r .\dbo\StoredProcedures\sp_InsertCustomer.sql
:r .\dbo\StoredProcedures\sp_GetOrderSummary.sql
:r .\dbo\StoredProcedures\sp_GetProductSales.sql

PRINT 'Deployment completed successfully.'
GO
