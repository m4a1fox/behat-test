#!/usr/bin/env bash
php artisan key:generate
php artisan config:clear
php artisan config:cache
php -S 127.0.0.1:8000 -t public