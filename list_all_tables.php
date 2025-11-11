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

    echo "✅ Conectado a PostgreSQL en: $db_name\n\n";

    // Listar todas las tablas
    echo "📋 Todas las tablas en la BD:\n";
    $stmt = $conn->query("
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        ORDER BY table_name
    ");
    
    $tables = $stmt->fetchAll(PDO::FETCH_ASSOC);
    if (count($tables) > 0) {
        foreach ($tables as $table) {
            echo "  - " . $table['table_name'] . "\n";
        }
    } else {
        echo "  (No hay tablas)\n";
    }

    // Buscar tabla bitacora (con diferentes esquemas posibles)
    echo "\n🔍 Buscando tabla 'bitacora':\n";
    $stmt = $conn->query("
        SELECT table_schema, table_name 
        FROM information_schema.tables 
        WHERE table_name = 'bitacora'
    ");
    
    $bitacora_tables = $stmt->fetchAll(PDO::FETCH_ASSOC);
    if (count($bitacora_tables) > 0) {
        echo "✅ Tabla encontrada:\n";
        foreach ($bitacora_tables as $table) {
            echo "  - Schema: {$table['table_schema']}, Tabla: {$table['table_name']}\n";
        }
        
        // Mostrar estructura
        echo "\n📐 Estructura de la tabla bitacora:\n";
        $stmt = $conn->query("
            SELECT column_name, data_type, is_nullable
            FROM information_schema.columns 
            WHERE table_name = 'bitacora'
            ORDER BY ordinal_position
        ");
        $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($columns as $col) {
            $nullable = $col['is_nullable'] === 'YES' ? 'NULL' : 'NOT NULL';
            echo "  - {$col['column_name']}: {$col['data_type']} ($nullable)\n";
        }
        
        // Contar registros
        echo "\n📊 Datos en bitacora:\n";
        $stmt = $conn->query("SELECT COUNT(*) as total FROM bitacora");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        echo "  Total de registros: " . $result['total'] . "\n";
        
        if ($result['total'] > 0) {
            echo "\n  Últimos 5 registros:\n";
            $stmt = $conn->query("
                SELECT * FROM bitacora 
                ORDER BY id_bit DESC 
                LIMIT 5
            ");
            $bitacoras = $stmt->fetchAll(PDO::FETCH_ASSOC);
            foreach ($bitacoras as $b) {
                echo "    - ID: {$b['id_bit']} | Usuario: {$b['usuario_id']} | Acción: {$b['accion']} | Fecha: {$b['fecha_accion']}\n";
            }
        }
        
    } else {
        echo "❌ Tabla 'bitacora' NO encontrada\n";
    }

} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}
?>
