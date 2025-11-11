<?php
// Conexión directa a PostgreSQL sin Laravel
$db_host = 'localhost';
$db_name = 'appwebcargahoraria';
$db_user = 'postgres';
$db_password = 'CAMPEON';
$db_port = 5432;

try {
    $conn = new PDO(
        "pgsql:host=$db_host;port=$db_port;dbname=$db_name",
        $db_user,
        $db_password,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    echo "✅ Conectado a PostgreSQL\n\n";

    // Contar registros
    $stmt = $conn->query("SELECT COUNT(*) as total FROM bitacora");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    $count = $result['total'];

    echo "📊 Total de registros en bitacora: $count\n\n";

    if ($count > 0) {
        echo "📋 Últimos 10 registros:\n";
        $stmt = $conn->query("
            SELECT 
                id_bit, 
                usuario_id, 
                accion, 
                modulo, 
                fecha_accion
            FROM bitacora 
            ORDER BY id_bit DESC 
            LIMIT 10
        ");
        
        $bitacoras = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($bitacoras as $b) {
            echo sprintf(
                "ID: %d | Usuario: %d | Acción: %s | Módulo: %s | Fecha: %s\n",
                $b['id_bit'],
                $b['usuario_id'],
                $b['accion'],
                $b['modulo'],
                $b['fecha_accion']
            );
        }
    } else {
        echo "⚠️  No hay registros en la bitácora\n";
        
        // Verificar estructura de la tabla
        echo "\n📐 Estructura de la tabla bitacora:\n";
        $stmt = $conn->query("
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'bitacora'
        ");
        $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($columns as $col) {
            echo "  - {$col['column_name']}: {$col['data_type']}\n";
        }
    }

} catch (PDOException $e) {
    echo "❌ Error de conexión: " . $e->getMessage() . "\n";
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}
?>
