# Use the official PHP FPM image as base
FROM php:8.2.20-fpm

ARG UID=1000

# Create user and some useful stuff
RUN adduser -u ${UID} --disabled-password --gecos "" appuser
RUN mkdir /home/appuser/.ssh
RUN chown -R appuser:appuser /home/appuser/
RUN echo "StrictHostKeyChecking no" >> /home/appuser/.ssh/config
RUN echo "export COLUMNS=300" >> /home/appuser/.bashrc
RUN echo "alias pa='php artisan'" >> /home/appuser/.bashrc

# Install packages and PHP extensions
RUN apt update \
    && apt install -y git acl openssl openssh-client wget zip vim libssh-dev \
    && apt install -y libpng-dev zlib1g-dev libzip-dev libxml2-dev libicu-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip sockets \
    && pecl install xdebug \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache xdebug

# Install and update composer
RUN curl https://getcomposer.org/composer.phar -o /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    && composer self-update

# Set working directory
WORKDIR /var/www/html

# Copiar archivos de la aplicación Laravel
COPY src /var/www/html

# Copiar el archivo .env
COPY src/.env /var/www/html/.env

# Set permissions
RUN chown -R appuser:appuser /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Generate application key
RUN php artisan key:generate

# Switch to non-root user
USER appuser

# Set alias for artisan command
RUN echo "alias pa='php artisan'" >> /home/appuser/.bashrc

# Expose port 9000 (optional if you want to run PHP FPM)
EXPOSE 9000

# Start PHP FPM
##CMD ["php-fpm"]
# Start only for test no production
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]

