#!/bin/sh
set -e

# Ensure correct permissions for data directories if mounted as volumes
# These directories should be owned by www-data
# This is a safeguard, as Dockerfile already tries to set this up.
# However, volume mounts can sometimes override initial permissions.
chown -R www-data:www-data /var/www/html/data /var/www/html/public/viewcache /var/www/html/plugins || true
chmod -R 755 /var/www/html/data /var/www/html/public/viewcache /var/www/html/plugins || true

# Ensure config.php exists, copy from dist if not (also done in Dockerfile, but good for entrypoint too)
if [ ! -f /var/www/html/data/config.php ]; then
    cp /var/www/html/config-dist.php /var/www/html/data/config.php
    chown www-data:www-data /var/www/html/data/config.php
fi

# Execute the CMD
exec "$@"
