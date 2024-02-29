#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт.
set -xe
#Перезаливаем конфиг сервиса nginx для раздачи статики
sudo cp -rf sausage-store.conf /etc/nginx/sites-available/sausage-store.conf
#Делаем символическую ссылку в sites enabled
sudo ln -s /etc/nginx/sites-available/sausage-store.conf /etc/nginx/sites-enabled/ || true
#Переходим в домашнюю папку бзера frontend
cd /opt/sausage-store/static/
# Удаляем старый артефакт
sudo rm -rf sausage-store-front.tar.gz
#Скачиваем новый артефакт из нексуса
sudo curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-front.tar.gz ${NEXUS_REPO_URL}/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
tar -zxf ./sausage-store-front.tar.gz ||true
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl enable nginx
sudo systemctl restart nginx
