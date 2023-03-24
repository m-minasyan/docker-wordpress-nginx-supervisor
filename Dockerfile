FROM php:8.2-fpm-alpine

# Install required packages and PHP extensions
RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    wget \
    unzip \
    libzip-dev \
    && docker-php-ext-install mysqli zip \
    && docker-php-ext-enable mysqli

# Remove default Nginx configuration and add custom configuration
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Download and install WordPress
RUN wget https://wordpress.org/latest.zip \
    && unzip latest.zip -d /var/www/ \
    && rm latest.zip \
    && chown -R www-data:www-data /var/www/wordpress

# Configure supervisord to manage both nginx and php-fpm
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the HTTP port
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

