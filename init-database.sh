#!/bin/bash

# Este script inicializa la base de datos para Render
# Se ejecuta como parte del start-server.sh

echo "🗄️  Inicializando base de datos..."

# Ejecutar dentro de Laravel Tinker
php artisan tinker <<'EOF'
use Illuminate\Support\Facades\DB;

try {
    // Crear schema
    DB::statement('CREATE SCHEMA IF NOT EXISTS carga_horaria');
    echo "✅ Schema 'carga_horaria' verificado\n";

    // Cambiar search_path
    DB::statement("SET search_path = carga_horaria, public");
    echo "✅ search_path configurado\n";

    // Verificar tablas críticas
    $tables = [
        'usuarios',
        'docentes', 
        'grupos',
        'periodos_academicos',
        'asignaciones',
        'asistencias',
        'inasistencias'
    ];

    foreach ($tables as $table) {
        $exists = DB::selectOne("
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'carga_horaria' 
                AND table_name = ?
            )", [$table]);
        
        if ($exists->exists ?? false) {
            echo "✅ Tabla '$table' existe\n";
        } else {
            echo "⚠️  Tabla '$table' NO existe (será creada por migraciones)\n";
        }
    }

    echo "✅ Inicialización de BD completada\n";
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
    exit(1);
}

exit();
EOF
