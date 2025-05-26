# Use an official PHP runtime as a parent image
FROM php:8.2-fpm-alpine

# Set maintainer label (optional)
LABEL maintainer="Your Name <you@example.com>"

# Arguments - for versions or other build-time configurations
ARG APP_VERSION=latest
ARG UID=82
ARG GID=82

# Environment variables
ENV DOCKER_USER=www-data
ENV PATH="/var/www/html/vendor/bin:$PATH"

# Create www-data user and group if they don't exist
# 82 is the standard uid/gid for "www-data" in Alpine
RUN set -eux;     addgroup -g ${GID} -S ${DOCKER_USER} || true;     adduser -u ${UID} -D -S -G ${DOCKER_USER} ${DOCKER_USER} || true;

# Install system dependencies
# - Nginx for web server
# - Supervisor for process management (PHP-FPM & Nginx)
# - Common PHP extensions (referencing grocy/grocy-docker Containerfile-backend)
# - Git and Composer for build stage (will be removed later if using multi-stage)
# - Other utilities like wget, gnupg (can be removed in final stage if not needed at runtime)
RUN apk update && apk add --no-cache     nginx     supervisor     git     composer     # PHP extensions - many are included in php:8.2-fpm-alpine, add specific ones if missing
    # Check what's needed by the application based on `Containerfile-backend` and current app
    # Example: docker-php-ext-install pdo_sqlite gd exif fileinfo iconv ldap simplexml tokenizer curl mbstring zip intl
    # For Alpine, many extensions are installed via apk add php82-extensionName
    php82-ctype     php82-exif     php82-fileinfo     php82-gd     php82-iconv     php82-ldap     php82-pdo_sqlite     php82-simplexml     php82-tokenizer     php82-phar     php82-curl     php82-mbstring     php82-openssl     php82-zip     php82-intl

# Set working directory
WORKDIR /var/www/html

# Copy application source code
# Ensure .dockerignore is properly set up to exclude .git, data/, etc.
COPY . .

# Ensure the /var/www/html/data directory exists and is writable by www-data
# This is based on common practice for Grocy and where config.php is often placed.
# Adjust if your application has different writable directory needs.
RUN mkdir -p /var/www/html/data /var/www/html/public/viewcache &&     chown -R ${DOCKER_USER}:${DOCKER_USER} /var/www/html/data /var/www/html/public/viewcache /var/www/html/plugins &&     chmod -R 755 /var/www/html/data /var/www/html/public/viewcache /var/www/html/plugins

# Set correct ownership for the entire application directory
RUN chown -R ${DOCKER_USER}:${DOCKER_USER} /var/www/html

# Install PHP dependencies using Composer
# Running as DOCKER_USER to avoid permission issues with composer cache if run as root
USER ${DOCKER_USER}
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Switch back to root for any further privileged operations if needed
USER root

# Basic cleanup of apk cache (composer cache is handled by composer itself or user-level cleanup)
RUN rm -rf /var/cache/apk/*

# Application specific setup:
# Copy config-dist.php to data/config.php if it doesn't exist.
# This step might be better handled by an entrypoint script for more flexibility at runtime.
# For now, we ensure a default config is present if the volume mount for 'data' is empty.
RUN if [ ! -f /var/www/html/data/config.php ]; then       cp /var/www/html/config-dist.php /var/www/html/data/config.php &&       chown ${DOCKER_USER}:${DOCKER_USER} /var/www/html/data/config.php;     fi

# Copy Nginx site configuration
# Assuming nginx-site.conf is at the root of the build context for now
COPY nginx-site.conf /etc/nginx/http.d/default.conf

# Copy Supervisor configuration
# Assuming supervisord.conf is at the root of the build context for now
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy the entrypoint script
# Assuming entrypoint.sh is at the root of the build context for now
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80 for Nginx
EXPOSE 80

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command to run Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
