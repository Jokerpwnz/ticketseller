# Dockerfile for PHP + Laravel project

# Use the latest official PHP image
FROM php:8.3-fpm

# Set working directory in the container
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    git \
    nano \
    nginx \
    build-essential \
    locales \
    jpegoptim optipng pngquant gifsicle \
    vim \
    curl \
    libzip-dev \
    libpq-dev \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Install PHP extensions and composer
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Redis extension for PHP
RUN pecl install redis && docker-php-ext-enable redis

# Install MongoDB extension
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the existing application directory to the container
COPY . /var/www

# Ensure the storage directory exists before setting permissions
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Copy Nginx configuration file# Copy Nginx configuration file
COPY dockerfiles/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Add a local domain for pretty URLs via an entrypoint script
#COPY dockerfiles/add-hosts.sh /usr/local/bin/add-hosts.sh
#RUN chmod +x /usr/local/bin/add-hosts.sh
#ENTRYPOINT ["/usr/local/bin/add-hosts.sh"]
#
## Expose ports for Nginx
#EXPOSE 80
#EXPOSE 443

# Start Nginx and PHP-FPM server
CMD ["sh", "-c", "nginx && php-fpm"]

# Optimize performance by using Opcache
RUN docker-php-ext-install opcache

# Create opcache.ini file with recommended settings
RUN echo "opcache.memory_consumption=256" > /usr/local/etc/php/conf.d/opcache.ini
RUN echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/opcache.ini
RUN echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini
