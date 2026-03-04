# sync-cursor.ps1
# Sincroniza ishango-cursor-rules a los repos ERP y Motor.
# Uso: cd C:\dev\ishango-cursor-rules ; .\sync-cursor.ps1

$erp   = "C:\dev\iShangoERP\.cursor\rules"
$motor = "C:\dev\ishango-motor\.cursor\rules"
$here  = $PSScriptRoot

# Validaciones
foreach ($path in @($erp, $motor)) {
    if (-not (Test-Path $path)) {
        Write-Error "Ruta no encontrada: $path"
        exit 1
    }
}

# --- 1. Shared a ERP y Motor ---
Write-Host "[1/3] Shared -> ERP y Motor" -ForegroundColor Cyan
$sharedSrc = "$here\rules\shared"

Get-ChildItem "$sharedSrc\*.mdc" | ForEach-Object {
    Copy-Item $_.FullName -Destination $erp   -Force
    Copy-Item $_.FullName -Destination $motor -Force
    Write-Host "  shared: $($_.Name)"
}

$erpModules   = "$erp\modules"
$motorModules = "$motor\modules"
New-Item -ItemType Directory -Path $erpModules   -Force | Out-Null
New-Item -ItemType Directory -Path $motorModules -Force | Out-Null
Get-ChildItem "$sharedSrc\modules\*.mdc" | ForEach-Object {
    Copy-Item $_.FullName -Destination $erpModules   -Force
    Copy-Item $_.FullName -Destination $motorModules -Force
    Write-Host "  module: $($_.Name)"
}

# --- 2. ERP-only a iShangoERP ---
# workflow.mdc, actualizacion-reglas.mdc y fuente-de-verdad.mdc vienen de shared (cerebro unico)
Write-Host "[2/3] ERP-only -> iShangoERP" -ForegroundColor Cyan
$erpSrc = "$here\rules\erp"
$erpExclude = @("workflow.mdc", "actualizacion-reglas-erp.mdc", "erp-source-of-truth.mdc")
Get-ChildItem "$erpSrc\*.mdc" | Where-Object { $_.Name -notin $erpExclude } | ForEach-Object {
    $destName = $_.Name
    $destPath = Join-Path $erp $destName
    Copy-Item $_.FullName -Destination $destPath -Force
    Write-Host "  erp: $destName"
}

# --- 3. Motor-only a ishango-motor ---
# workflow.mdc, actualizacion-reglas.mdc y fuente-de-verdad.mdc vienen de shared (cerebro unico)
Write-Host "[3/3] Motor-only -> ishango-motor" -ForegroundColor Cyan
$motorSrc = "$here\rules\motor"
$motorExclude = @("workflow-motor.mdc", "actualizacion-reglas-motor.mdc", "fuente-de-verdad.mdc")
Get-ChildItem "$motorSrc\*.mdc" | Where-Object { $_.Name -notin $motorExclude } | ForEach-Object {
    $destName = $_.Name `
        -replace "^root-motor\.mdc$",                 "root.mdc" `
        -replace "^actualizacion-reglas-motor\.mdc$", "actualizacion-reglas.mdc"
    $destPath = Join-Path $motor $destName
    Copy-Item $_.FullName -Destination $destPath -Force
    Write-Host "  motor: $destName"
}

$motorLayersSrc  = "$motorSrc\layers"
$motorLayersDest = "$motor\layers"
if (Test-Path $motorLayersSrc) {
    New-Item -ItemType Directory -Path $motorLayersDest -Force | Out-Null
    Copy-Item "$motorLayersSrc\*" -Destination $motorLayersDest -Recurse -Force
    Write-Host "  layers/ sincronizado"
}

Write-Host "Sync completo." -ForegroundColor Green
Write-Host "  ERP:   $erp"
Write-Host "  Motor: $motor"
