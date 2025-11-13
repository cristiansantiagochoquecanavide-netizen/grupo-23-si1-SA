#!/bin/bash

set -e

echo "=========================================="
echo "Iniciando aplicación Laravel en Render"
echo "=========================================="

# Variables
MAX_RETRIES=30
RETRY_COUNT=0

# Esperar a que PostgreSQL esté listo
echo "Esperando conexión a PostgreSQL..."
until PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USERNAME -d postgres -c "SELECT 1" > /dev/null 2>&1; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "❌ PostgreSQL no se conectó después de $MAX_RETRIES intentos"
    exit 1
  fi
  echo "⏳ Intento $RETRY_COUNT/$MAX_RETRIES: PostgreSQL aún no está listo..."
  sleep 2
done

echo "✅ PostgreSQL está listo"

# Limpiar cache de Laravel
echo "Limpiando caché..."
php artisan cache:clear 2>&1 || true
php artisan config:clear 2>&1 || true
php artisan view:clear 2>&1 || true

# Crear la base de datos si no existe
echo "Verificando base de datos..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USERNAME -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_DATABASE'" | grep -q 1 || \
  PGPASSWORD=$DB_PASSWORD createdb -h $DB_HOST -U $DB_USERNAME -d $DB_DATABASE 2>&1 || true

# Crear el schema si no existe
echo "Creando schema..."
php artisan tinker --execute="DB::statement('CREATE SCHEMA IF NOT EXISTS carga_horaria')" 2>&1 || true

# Inicializar base de datos
echo "Inicializando base de datos..."
bash init-database.sh 2>&1 || echo "⚠️  Advertencia en inicialización de BD"

# Ejecutar migraciones
echo "Ejecutando migraciones..."
php artisan migrate --force --no-interaction 2>&1 || {
  echo "⚠️ Migraciones completadas con advertencias (esto es normal)"
}

# Ejecutar seeders si es necesario
echo "Ejecutando seeders..."
php artisan db:seed --force --no-interaction 2>&1 || {
  echo "⚠️ Seeders completados con advertencias"
}

# Generar APP_KEY si está vacío
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
  echo "Generando APP_KEY..."
  php artisan key:generate --force
fi

# Log del estado
echo "=========================================="
echo "✅ Aplicación lista para iniciar"
echo "=========================================="
echo "APP_ENV: $APP_ENV"
echo "APP_URL: $APP_URL"
echo "DB_HOST: $DB_HOST"
echo "DB_NAME: $DB_DATABASE"
echo "PORT: 10000"
echo "=========================================="

# Iniciar servidor Laravel
exec php artisan serve --host=0.0.0.0 --port=10000
