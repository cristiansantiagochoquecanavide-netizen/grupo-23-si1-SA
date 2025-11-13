<?php
/**
 * Script de prueba para verificar que los endpoints de reportes están accesibles
 */

require 'vendor/autoload.php';
require 'bootstrap/app.php';

use Illuminate\Support\Facades\DB;

// Verificar que existan datos en las tablas
echo "=== VERIFICACIÓN DE DATOS EN TABLAS ===\n\n";

echo "📊 Periodos Académicos:\n";
$periodos = DB::table('periodos_academicos')->count();
echo "  Total: $periodos\n";
if ($periodos > 0) {
    $sample = DB::table('periodos_academicos')->limit(2)->get();
    foreach ($sample as $p) {
        echo "    - {$p->nombre} ({$p->fecha_inicio} a {$p->fecha_fin})\n";
    }
}

echo "\n📖 Docentes:\n";
$docentes = DB::table('docentes')->count();
echo "  Total: $docentes\n";
if ($docentes > 0) {
    $sample = DB::table('docentes')->limit(2)->get();
    foreach ($sample as $d) {
        echo "    - {$d->nombre}\n";
    }
}

echo "\n👥 Grupos:\n";
$grupos = DB::table('grupos')->count();
echo "  Total: $grupos\n";
if ($grupos > 0) {
    $sample = DB::table('grupos')->limit(2)->get();
    foreach ($sample as $g) {
        echo "    - {$g->nombre}\n";
    }
}

echo "\n📋 Asignaciones:\n";
$asignaciones = DB::table('asignaciones')->count();
echo "  Total: $asignaciones\n";

echo "\n📝 Asistencias:\n";
$asistencias = DB::table('asistencias')->count();
echo "  Total: $asistencias\n";

echo "\n❌ Inasistencias:\n";
$inasistencias = DB::table('inasistencias')->count();
echo "  Total: $inasistencias\n";

echo "\n=== CONFIGURACIÓN DE RUTAS ===\n";
echo "\nVerifica que en routes/api.php existan:\n";
echo "  - GET /api/periodos-academicos (auth:sanctum)\n";
echo "  - GET /api/docentes (auth:sanctum)\n";
echo "  - GET /api/grupos (auth:sanctum)\n";
echo "  - POST /api/reportes/generar (auth:sanctum)\n";
echo "  - POST /api/reportes/compartir (auth:sanctum)\n";

echo "\n=== VERIFICACIÓN DE MIGRACIONES ===\n\n";
echo "✅ Base de datos:" . DB::connection()->getDatabaseName() . "\n";
echo "✅ Tabla 'periodos_academicos': " . (DB::table('periodos_academicos')->count() > 0 ? "SÍ" : "NO") . "\n";
echo "✅ Tabla 'docentes': " . (DB::table('docentes')->count() > 0 ? "SÍ" : "NO") . "\n";
echo "✅ Tabla 'grupos': " . (DB::table('grupos')->count() > 0 ? "SÍ" : "NO") . "\n";

?>
