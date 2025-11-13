param(
    [switch]$verbose = $false
)

Write-Host ""
Write-Host "CU17 QUICK START SCRIPT - Windows PowerShell" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Verificando archivos..." -ForegroundColor Yellow

$files = @(
  "app/Http/Controllers/Monitoreo_y_Reportes/ReportesController.php",
  "resources/js/pages/monitoreo/GenerarReportes.jsx",
  "resources/js/pages/monitoreo/GenerarReportes.css",
  "resources/js/pages/monitoreo/Monitoreo.jsx",
  "routes/api.php"
)

$allFilesExist = $true
foreach ($file in $files) {
  if (Test-Path $file) {
    Write-Host "  OK - $file" -ForegroundColor Green
  } else {
    Write-Host "  ERROR - $file" -ForegroundColor Red
    $allFilesExist = $false
  }
}

Write-Host ""
Write-Host "VERIFICACION COMPLETADA" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Recarga el navegador (Ctrl+F5)" -ForegroundColor Cyan
Write-Host "  2. Inicia sesion como Administrador" -ForegroundColor Cyan
Write-Host "  3. Ve a Monitoreo y Reportes" -ForegroundColor Cyan
Write-Host "  4. Deberias ver CU17 - Generar Reportes" -ForegroundColor Cyan
Write-Host "  5. Abre la consola del navegador (F12)" -ForegroundColor Cyan
Write-Host ""
