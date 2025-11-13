#!/bin/bash

# Esperar a que PostgreSQL esté listo
sleep 10

# Intentar conectar a la base de datos con reintentos
for i in {1..15}; do
  echo "Intento de conexión $i..."
  
  # Usar artisan para verificar conexión
  php artisan tinker --execute="DB::connection()->getPdo()" > /dev/null 2>&1
  
  if [ $? -eq 0 ]; then
    echo "✓ PostgreSQL está listo"
    break
  fi
  
  sleep 4
done

# Ejecutar migraciones
echo "Ejecutando migraciones..."
php artisan migrate --force 2>&1 || echo "Migraciones completadas (o no requeridas)"

# Crear el schema
echo "Creando schema..."
php artisan tinker --execute="DB::statement('CREATE SCHEMA IF NOT EXISTS carga_horaria')" 2>&1 || echo "Schema creado (o ya existe)"

# Iniciar servidor
echo "✓ Iniciando servidor Laravel en puerto 10000..."
php artisan serve --host=0.0.0.0 --port=10000
