# SqlPipelineDemo

Simple SQL Server database project with CI/CD deployment via GitHub Actions.

## Database
- **Server:** `localhost` (default instance)
- **Database:** `SqlPipelineDemo`
- **Auth:** Windows Authentication

## Folder structure

```
src/
├── 01_CreateDatabase.sql          # Creates the database (idempotent)
├── deploy.sql                     # Master deployment script (runs all objects in order)
└── dbo/
    ├── Tables/
    │   ├── Customers.sql
    │   ├── Orders.sql
    │   └── OrderItems.sql
    └── StoredProcedures/
        ├── sp_GetCustomerOrders.sql
        ├── sp_InsertCustomer.sql
        └── sp_GetOrderSummary.sql

.github/
└── workflows/
    └── deploy-db.yml              # GitHub Actions pipeline

deploy.ps1                         # PowerShell deployment helper (runs on self-hosted runner)
```

## Prerequisites (local machine)

- SQL Server 2022 (default instance `MSSQLSERVER`) running on `localhost`
- Windows Authentication enabled
- [GitHub self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) installed and registered on this machine, labeled `sql-db`

## Local deployment (test before pushing)

```powershell
# Deploy to localhost
.\deploy.ps1 -ServerInstance localhost -Database SqlPipelineDemo -ScriptPath ./src
```

## Pipeline flow

1. Commit SQL changes to `main`
2. GitHub Actions runs `deploy-db.yml` on the self-hosted runner
3. `deploy.ps1` executes each `.sql` file in order against `localhost`
4. Changes are applied to the local `SqlPipelineDemo` database

> **Why a self-hosted runner?** GitHub-hosted runners run in the cloud and cannot connect to `localhost` on your machine. A self-hosted runner installed locally can.
