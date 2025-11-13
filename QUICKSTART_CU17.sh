#!/bin/bash
# 🚀 CU17 QUICK START SCRIPT
# Script para verificar rápidamente que CU17 funciona

echo "🔍 ========== CU17 QUICK VERIFICATION =========="
echo ""

echo "📂 1️⃣ Verificando archivos..."
files=(
  "app/Http/Controllers/Monitoreo_y_Reportes/ReportesController.php"
  "resources/js/pages/monitoreo/GenerarReportes.jsx"
  "resources/js/pages/monitoreo/GenerarReportes.css"
  "resources/js/pages/monitoreo/Monitoreo.jsx"
  "routes/api.php"
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "  ✅ $file"
  else
    echo "  ❌ $file (FALTA)"
  fi
done

echo ""
echo "🔌 2️⃣ Verificando rutas API..."
php artisan route:list | grep reportes || echo "  ❌ Rutas no encontradas"

echo ""
echo "🧪 3️⃣ Verificando sintaxis PHP..."
php -l app/Http/Controllers/Monitoreo_y_Reportes/ReportesController.php && echo "  ✅ Sintaxis correcta" || echo "  ❌ Error de sintaxis"

echo ""
echo "🎯 4️⃣ Próximos pasos:"
echo "  1. Recarga el navegador (Ctrl+F5)"
echo "  2. Inicia sesión como Administrador"
echo "  3. Ve a Monitoreo y Reportes"
echo "  4. Deberías ver CU17 - Generar Reportes"
echo "  5. Abre la consola (F12) para ver logs"

echo ""
echo "✅ ========== VERIFICACIÓN COMPLETADA =========="
