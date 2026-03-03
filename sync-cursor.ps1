# sync-cursor.ps1
# Sincroniza el contenido de ishango-cursor-rules a los repos ERP y Motor.
# Correr cada vez que se modifica cualquier archivo en este repo.
#
# Uso:
#   cd C:\dev\ishango-cursor-rules
#   .\sync-cursor.ps1
#
# Verificar que las rutas coincidan con tu entorno local:
$erp   = "C:\dev\iShangoERP\.cursor\rules"
$motor = "C:\dev\ishango-motor\.cursor\rules"
$here  = $PSScriptRoot

# ---------------------------------------------------------------------------
# Validaciones previas
# ---------------------------------------------------------------------------
foreach ($path in @($erp, $motor)) {
    if (-not (Test-Path $path)) {
        Write-Error "Ruta no encontrada: $path — corregir en sync-cursor.ps1"
        exit 1
    }
}

# ---------------------------------------------------------------------------
# 1. Shared → ERP y Motor
#    Copia ishango-*.mdc y modules/ a los dos repos.
# ---------------------------------------------------------------------------
Write-Host "`n[1/3] Shared → ERP y Motor" -ForegroundColor Cyan

$sharedSrc = "$here\rules\shared"

# Archivos raíz de shared (ishango-*.mdc)
Get-ChildItem "$sharedSrc\*.mdc" | ForEach-Object {
    Copy-Item $_.FullName -Destination $erp   -Force
    Copy-Item $_.FullName -Destination $motor -Force
    Write-Host "  shared: $($_.Name)"
}

# modules/ — crear carpeta si no existe y copiar todo
$erpModules   = "$erp\modules"
$motorModules = "$motor\modules"
New-Item -ItemType Directory -Path $erpModules   -Force | Out-Null
New-Item -ItemType Directory -Path $motorModules -Force | Out-Null
Get-ChildItem "$sharedSrc\modules\*.mdc" | ForEach-Object {
    Copy-Item $_.FullName -Destination $erpModules   -Force
    Copy-Item $_.FullName -Destination $motorModules -Force
    Write-Host "  module: $($_.Name)"
}

# ---------------------------------------------------------------------------
# 2. ERP-only → iShangoERP
#    Copia erp-*.mdc, workflow.mdc, root.mdc, ask-mode-expert.mdc y
#    actualizacion-reglas-erp.mdc (renombrado a actualizacion-reglas.mdc).
# ---------------------------------------------------------------------------
Write-Host "`n[2/3] ERP-only → iShangoERP" -ForegroundColor Cyan

$erpSrc = "$here\rules\erp"
Get-ChildItem "$erpSrc\*.mdc" | ForEach-Object {
    # actualizacion-reglas-erp.mdc → actualizacion-reglas.mdc
    $destName = $_.Name -replace "^actualizacion-reglas-erp\.mdc$", "actualizacion-reglas.mdc"
    $destPath = Join-Path $erp $destName
    Copy-Item $_.FullName -Destination $destPath -Force
    Write-Host "  erp: $destName"
}

# ---------------------------------------------------------------------------
# 3. Motor-only → ishango-motor
#    Copia workflow-motor.mdc→workflow.mdc, root-motor.mdc→root.mdc,
#    actualizacion-reglas-motor.mdc→actualizacion-reglas.mdc y el resto.
# ---------------------------------------------------------------------------
Write-Host "`n[3/3] Motor-only → ishango-motor" -ForegroundColor Cyan

$motorSrc = "$here\rules\motor"
Get-ChildItem "$motorSrc\*.mdc" | ForEach-Object {
    $destName = $_.Name `
        -replace "^workflow-motor\.mdc$",             "workflow.mdc" `
        -replace "^root-motor\.mdc$",                 "root.mdc" `
        -replace "^actualizacion-reglas-motor\.mdc$", "actualizacion-reglas.mdc"
    $destPath = Join-Path $motor $destName
    Copy-Item $_.FullName -Destination $destPath -Force
    Write-Host "  motor: $destName"
}

# layers/ — si existe en motor, sincronizar
$motorLayersSrc  = "$motorSrc\layers"
$motorLayersDest = "$motor\layers"
if (Test-Path $motorLayersSrc) {
    New-Item -ItemType Directory -Path $motorLayersDest -Force | Out-Null
    Copy-Item "$motorLayersSrc\*" -Destination $motorLayersDest -Recurse -Force
    Write-Host "  layers/ sincronizado"
}

# ---------------------------------------------------------------------------
Write-Host "`nSync completo." -ForegroundColor Green
Write-Host "  ERP:   $erp"
Write-Host "  Motor: $motor"
