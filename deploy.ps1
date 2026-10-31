# deploy.ps1
# Deploys SQL change scripts to a local SQL Server instance using sqlcmd.
#
# Designed to run on a GitHub self-hosted runner installed on the same machine
# as the SQL Server instance (so it can reach localhost).
#
# Examples:
#   .\deploy.ps1 -ServerInstance localhost -Database SqlPipelineDemo -ScriptPath ./src
#   .\deploy.ps1 -ServerInstance localhost\MSSQLSERVER01 -Database SqlPipelineDemo -ScriptPath ./src

param(
    [Parameter(Mandatory = $true)]
    [string] $ServerInstance,

    [Parameter(Mandatory = $true)]
    [string] $Database,

    [Parameter(Mandatory = $true)]
    [string] $ScriptPath,

    [switch] $TrustServerCertificate
)

$ErrorActionPreference = 'Stop'

# Resolve sqlcmd.exe (SQL Server 2022 / ODBC 17 or 18 tools)
$sqlcmdPaths = @(
    "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\sqlcmd.exe",
    "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\180\Tools\Binn\sqlcmd.exe"
)
$sqlcmd = $sqlcmdPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $sqlcmd) {
    throw "sqlcmd.exe not found. Install the SQL Server command-line tools."
}
Write-Host "Using sqlcmd: $sqlcmd" -ForegroundColor Cyan

# Resolve the master deploy script
$deployScript = Join-Path $ScriptPath "deploy.sql"
if (-not (Test-Path $deployScript)) {
    throw "deploy.sql not found at $deployScript"
}

# Build sqlcmd arguments
$arguments = @(
    "-S", $ServerInstance,
    "-E",                                          # Windows Authentication
    "-d", "master",                                # start in master (deploy.sql creates/switches DB)
    "-i", $deployScript,
    "-b",                                          # stop on error
    "-V", "16"                                     # severity level to treat as error
)
if ($TrustServerCertificate) {
    $arguments += "-C"                             # trust server certificate
}

# Pass variables so deploy.sql can reference them if needed
$arguments += "-v", "DatabaseName=$Database"

# Run from the script folder so ':r' relative paths in deploy.sql resolve correctly.
$originalLocation = Get-Location
try {
    Set-Location $ScriptPath

    Write-Host "Deploying database '$Database' on '$ServerInstance'..." -ForegroundColor Cyan
    Write-Host "Working directory: $ScriptPath" -ForegroundColor Cyan
    Write-Host "Script: $deployScript" -ForegroundColor Cyan
    Write-Host ""

    & $sqlcmd @arguments

    if ($LASTEXITCODE -ne 0) {
        throw "sqlcmd exited with code $LASTEXITCODE"
    }

    Write-Host ""
    Write-Host "Deployment succeeded!" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "Deployment FAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Set-Location $originalLocation
}
