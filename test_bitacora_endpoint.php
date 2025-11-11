<?php
// Prueba del endpoint /api/bitacora
header('Content-Type: application/json');

// Simular una solicitud autenticada
$token = 'test-token'; // O el token real del usuario admin

// Hacer la prueba directamente con Eloquent
require_once __DIR__ . '/bootstrap/app.php';

$app = app();

use App\Models\Bitacora;

try {
    $bitacoras = Bitacora::with('usuario')
        ->orderByDesc('fecha_accion')
        ->paginate(50);

    echo json_encode([
        'success' => true,
        'message' => 'Datos recuperados correctamente',
        'data' => $bitacoras->items(),
        'pagination' => [
            'current_page' => $bitacoras->currentPage(),
            'last_page' => $bitacoras->lastPage(),
            'per_page' => $bitacoras->perPage(),
            'total' => $bitacoras->total(),
            'from' => $bitacoras->firstItem(),
            'to' => $bitacoras->lastItem(),
        ]
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

} catch (\Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ], JSON_PRETTY_PRINT);
}
?>
