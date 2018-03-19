#!/bin/bash

# /usr/local/bin/start.sh
# Start nginx service

## handle termination gracefully

_term() {
  echo "Terminating nginx + php-fpm..."
  service nginx stop
  service php7.0-fpm stop
  exit 0
}

trap _term SIGTERM

service php7.0-fpm start
chmod 666 /var/run/php-fpm.socket

service nginx start

wait
