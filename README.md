# Docker PHP + NGINX + Oracle + Node.js + Python + OpenCV + Chromium

Ambiente completo Dockerizado com Ubuntu 24.04, ideal para aplicações PHP (Laravel, etc.), integração com Oracle (OCI8), suporte a Node.js, Python com OpenCV, e visualização via Chromium.

---

## 📦 Tecnologias e Componentes Instalados

- **PHP 8.3** + FPM + extensões úteis
- **NGINX** como servidor web
- **Oracle Instant Client 23.7** + OCI8 (via PECL)
- **Composer** com `barryvdh/laravel-dompdf`
- **Node.js 22**
- **Chromium Browser**
- **Python 3 + Virtualenv**
  - `opencv-python` para visão computacional
  - `pyzbar` para leitura de códigos de barras e QR Code
- **libzbar0**, **libasound2t64**, e outras dependências úteis


### 1. Clonar o Projeto

```bash
https://github.com/pedronasc/nginx-sga.git
cd nginx-sga

# Baixando Instant Client
wget --content-disposition https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linuxx64.zip
wget --content-disposition https://download.oracle.com/otn_software/linux/instantclient/instantclient-sdk-linuxx64.zip

# Descompactar Instant Client
unzip -o instantclient-basic-linux*.zip
unzip -o instantclient-sdk-linux*.zip

## 🚀 Como Usar

# Cria a imagem do conteiner com o nome nginx-sga:v1.0
docker build -t unifev/nginx-sga:v1.0 .

# Executa o container imagem se tiver upgrade
docker-compose up --build -d

http://<--host-docker-->:8180/

# Stopa o conteiner e recria 
docker compose down && docker compose up -d

# Stopa o conteiner e recria com build
docker compose down && docker compose up --build -d
