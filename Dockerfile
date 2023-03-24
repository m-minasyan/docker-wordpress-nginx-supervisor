FROM wordpress:6.1.1-php8.2-fpm-alpine

# Install required packages
RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    wget \
    unzip

# Remove default Nginx configuration and add custom configuration
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx-site.conf /etc/nginx/conf.d/wordpress.conf

# Configure supervisord to manage both nginx and php-fpm
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the HTTP port
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]