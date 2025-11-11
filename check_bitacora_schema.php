<?php
// Conexión directa a PostgreSQL sin Laravel
$db_host = 'localhost';
$db_name = 'appwebcargahoraria';
$db_user = 'postgres';
$db_password = 'CAMPEON';
$db_port = 5432;
$db_schema = 'carga_horaria';

try {
    $conn = new PDO(
        "pgsql:host=$db_host;port=$db_port;dbname=$db_name",
        $db_user,
        $db_password,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    echo "✅ Conectado a PostgreSQL\n";
    echo "📍 BD: $db_name | Schema: $db_schema\n\n";

    // Contar registros en el schema correcto
    $stmt = $conn->query("SET search_path TO $db_schema;");
    
    $stmt = $conn->query("SELECT COUNT(*) as total FROM bitacora");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    $count = $result['total'];

    echo "📊 Total de registros en bitacora: $count\n\n";

    if ($count > 0) {
        echo "📋 Últimos 10 registros:\n";
        $stmt = $conn->query("
            SELECT 
                id_bit, 
                id_usuario, 
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
                "ID: %d | Usuario: %s | Acción: %s | Módulo: %s | Fecha: %s\n",
                $b['id_bit'],
                $b['id_usuario'] ?? 'NULL',
                $b['accion'],
                $b['modulo'],
                $b['fecha_accion']
            );
        }
    } else {
        echo "⚠️  No hay registros en la bitácora\n";
    }

} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}
?>
