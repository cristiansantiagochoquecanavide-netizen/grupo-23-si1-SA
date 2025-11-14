# ===============================
# ETAPA 1: PHP DEPENDENCIES
# ===============================
FROM composer:2 AS php-build

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

COPY . .

RUN mkdir -p bootstrap/cache storage/logs storage/framework \
    && chmod -R 777 bootstrap storage


# ===============================
# ETAPA 2: VITE + REACT BUILD
# ===============================
FROM node:18 AS vite-build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build


# ===============================
# ETAPA 3: FINAL IMAGE (Apache + PHP)
# ===============================
FROM php:8.2-apache

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

RUN a2enmod rewrite

# Copiar código fuente SIN node_modules ni vendor
COPY . .

# Copiar Vite build desde etapa 2
COPY --from=vite-build /app/public/build ./public/build

# Copiar vendor desde etapa 1
COPY --from=php-build /app/vendor ./vendor

RUN mkdir -p bootstrap/cache storage \
    && chmod -R 777 bootstrap storage

EXPOSE 8080

CMD ["bash", "start-server.sh"]
