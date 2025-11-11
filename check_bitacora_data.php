<?php
require 'vendor/autoload.php';
require 'bootstrap/app.php';

use App\Models\Bitacora;
use Illuminate\Support\Facades\DB;

try {
    // Verificar conexión
    DB::connection()->getPdo();
    echo "✅ Conectado a la BD\n\n";

    // Contar registros
    $count = Bitacora::count();
    echo "📊 Total de registros en bitacora: $count\n\n";

    // Mostrar últimos 5 registros
    if ($count > 0) {
        echo "📋 Últimos 5 registros:\n";
        $bitacoras = Bitacora::with('usuario')
            ->orderByDesc('id_bit')
            ->limit(5)
            ->get();

        foreach ($bitacoras as $b) {
            $usuario = $b->usuario ? $b->usuario->nombre_usuario : 'Sistema';
            echo "ID: {$b->id_bit} | Usuario: $usuario | Acción: {$b->accion} | Módulo: {$b->modulo} | Fecha: {$b->fecha_accion}\n";
        }
    } else {
        echo "❌ No hay registros en la bitácora\n";
    }

    // Verificar campos de la tabla
    echo "\n📐 Campos de la tabla bitacora:\n";
    $columns = DB::getSchemaBuilder()->getColumnListing('bitacora');
    foreach ($columns as $col) {
        echo "  - $col\n";
    }

} catch (\Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
    echo "Stack: " . $e->getTraceAsString() . "\n";
}
