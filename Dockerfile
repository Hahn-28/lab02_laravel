# Usa una imagen oficial de PHP con extensiones necesarias
FROM php:8.2-fpm

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl

# Instala Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia el código fuente
COPY . .

# Instala dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Da permisos a storage y bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Expone el puerto 8000
EXPOSE 8000

# Comando para iniciar Laravel con el servidor embebido
CMD if [ -z "$APP_KEY" ]; then php artisan key:generate --force; fi && php artisan serve --host=0.0.0.0 --port=8000
