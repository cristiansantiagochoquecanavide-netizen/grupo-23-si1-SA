#!/bin/bash

# Esperar a que PostgreSQL esté listo
sleep 5

# Ejecutar migraciones
php artisan migrate --force

# Crear el schema
php artisan tinker --execute="DB::statement('CREATE SCHEMA IF NOT EXISTS carga_horaria')"

# Iniciar servidor
php artisan serve --host=0.0.0.0 --port=10000
