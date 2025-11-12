FROM php:8.2-fpm

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    npm \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Instalar y compilar frontend
RUN npm install && npm run build

# Generar APP_KEY
RUN php artisan key:generate

# Exponer puerto
EXPOSE 10000

# Comando de inicio
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
