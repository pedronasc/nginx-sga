FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/opt/oracle

# Dependências principais + PHP + Python + Chrome + utilitários
RUN apt update && apt upgrade -y && \
    apt install -y software-properties-common curl gnupg unzip git vim \
    nginx \
    php8.3 php8.3-fpm php8.3-cli php8.3-common php8.3-opcache php8.3-readline \
    php8.3-mbstring php8.3-xml php8.3-curl php8.3-mysql php8.3-zip \
    php8.3-phar php8.3-intl php8.3-bcmath php8.3-calendar php8.3-posix \
    php8.3-ctype php8.3-fileinfo php8.3-xsl php8.3-soap php8.3-ftp \
    php8.3-pdo php8.3-pdo-pgsql php8.3-pgsql php8.3-gd php-pear php8.3-dev \
    build-essential \
    libaio-dev libasound2t64 \
    python3 python3-dev python3-venv python3-pip libopencv-dev libzbar0 \
    # Dependências para Chrome
    fonts-liberation libu2f-udev libvulkan1 \
    libxss1 xdg-utils libnss3 libatk-bridge2.0-0 libgtk-3-0 \
    libx11-xcb1 libxcb-dri3-0 libdrm2 wget && \
    # Instalação do Google Chrome (mais estável para Puppeteer)
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    composer require barryvdh/laravel-dompdf

# Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt install -y nodejs

# Oracle Instant Client
WORKDIR /opt/oracle_client
COPY instantclient_23_7 ./instantclient_23_7

RUN mkdir -p /opt/oracle && \
    cp -r instantclient_23_7/* /opt/oracle && \
    echo /opt/oracle > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    ln -sf /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1

# OCI8 via PECL
RUN echo "instantclient,/opt/oracle" | pecl install oci8 && \
    echo "extension=oci8.so" > /etc/php/8.3/mods-available/oci8.ini && \
    phpenmod oci8

# Ambiente Python com OpenCV + Pyzbar
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install opencv-python pyzbar

# Diretório padrão
WORKDIR /var/www/html/sga-web/

# Script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
