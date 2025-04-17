#!/bin/bash

# Inicia os serviços
service php8.3-fpm start
service nginx start

# Mantém o container vivo
tail -f /var/log/nginx/access.log
