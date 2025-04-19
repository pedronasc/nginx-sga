#!/bin/sh
#
##Script criado por Ricardo para atualizaç do sga em produç
#

SCRIPT="Atualiza_SGA.log"
LOG=~/docker/nginx-sga/atualiza_sgaprod/atualiza_sgaprod-$(date +%Y.%m.%d_%H:%M).log

DATAI=`date +%Y.%m.%d_%H:%M`
echo "$DATAI - Iniciado    $SCRIPT -    OK" >> $LOG

DATA=`date +%d.%m.%Y_%H:%M`


chmod 777 ~/docker/nginx-sga/htm/sga-web/ -Rf

rsync -rltpzuv --delete --stats --progress \
  --exclude=".env" \
  --exclude=".git" \
  --exclude=".gitattributes" \
  --exclude=".gitignore" \
  --exclude="storage/framework/sessions/" \
  -e ssh root@172.30.1.36:/htm/sgadev/sga-web/ ~/docker/nginx-sga/htm/sga-web/

# Recria diretorio de sessions caso não exita
mkdir -p ~/docker/nginx-sga/htm/sga-web/storage/framework/sessions

chmod 777 ~/docker/nginx-sga/htm/sga-web/ -Rf

docker exec -it nginx-sga npm install
docker exec -it nginx-sga composer install
docker exec -it nginx-sga npm run build

chmod 777 ~/docker/nginx-sga/htm/sga-web/ -Rf

DATAF=`date +%Y.%m.%d_%H:%M`
echo "$DATAF - Finalizado  $SCRIPT - OK" >> $LOG
