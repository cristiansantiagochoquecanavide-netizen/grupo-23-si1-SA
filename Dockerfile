# ============================
#  🟦 STAGE 1: Build de Vite
# ============================
FROM node:18 AS vite-build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build



# ===================================
#  🟧 STAGE 2: Imagen final de Laravel
# ===================================
FROM php:8.2-apache

# Instalar extensiones necesarias para Laravel + PostgreSQL
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    postgresql-client \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql opcache \
    && rm -rf /var/lib/apt/lists/*

# Habilitar mod_rewrite para Laravel
RUN a2enmod rewrite

# Configurar Apache
COPY ./deploy/apache.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# Copiar proyecto completo
COPY . .

# Copiar el build de Vite a la carpeta pública
COPY --from=vite-build /app/public/build ./public/build

# Instalar Composer (producción)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Crear permisos
RUN mkdir -p storage/logs bootstrap/cache && chmod -R 777 storage bootstrap/cache

# Exponer puerto (Render usa 10000)
EXPOSE 10000

# Iniciar Apache
CMD ["apache2-foreground"]
