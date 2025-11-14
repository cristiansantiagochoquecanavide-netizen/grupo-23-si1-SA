#!/bin/bash

echo "=========================================="
echo "Iniciando Laravel en Render"
echo "=========================================="

# Mostrar variables importantes (debug)
echo "APP_ENV=$APP_ENV"
echo "APP_DEBUG=$APP_DEBUG"
echo "DB_HOST=$DB_HOST"

# Limpiar caches viejas
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Compilar caches nuevas
php artisan config:cache
php artisan route:cache
php artisan view:cache || true
php artisan optimize

# Ejecutar migraciones sin bloquear si falla
echo "Ejecutando migraciones..."
php artisan migrate --force || true

echo "Iniciando servidor Laravel en puerto $PORT..."
php artisan serve --host 0.0.0.0 --port $PORT
