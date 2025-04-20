# Variáveis configuráveis
IMAGE_NAME=nginx-sga
DOCKER_USER=pedronasc
TAG=latest
FULL_IMAGE=$(DOCKER_USER)/$(IMAGE_NAME):$(TAG)

# 🔨 Build da imagem
build:
	docker build -t $(IMAGE_NAME) .

# 🏷️ Adiciona a tag com o nome do Docker Hub
tag:
	docker tag $(IMAGE_NAME) $(FULL_IMAGE)

# 🚀 Envia a imagem para o Docker Hub
push:
	docker push $(FULL_IMAGE)

# 🔁 Atalho que faz tudo de uma vez: build + tag + push
publish: build tag push

# ▶️ Roda a imagem localmente (só para teste)
run:
	docker run --rm -p 8080:80 $(FULL_IMAGE)

# 🔍 Verifica se a imagem existe localmente
check:
	docker images | grep $(IMAGE_NAME)

up:
	docker compose up -d

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f

restart:
	docker compose down && docker compose up -d

ps:
	docker compose ps

deploy:
	@echo "Deployando ambiente..."
	#docker compose pull
	docker compose up -d --build