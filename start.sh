#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}

if [ "$env" != "local" ]; then
    echo "Caching configuration..."
    [ -d "/var/www/expense/current" ] && (cd /var/www/expense/current && php artisan config:cache && php artisan view:cache)
fi

if [ "$role" = "app" ]; then

    exec apache2-foreground
    
elif [ "$role" = "queue" ]; then

    [ -d "/var/www/expense/current" ] && (cd /var/www/expense/current && php artisan queue:work)

fi
