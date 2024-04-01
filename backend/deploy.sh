#! /bin/bash

#Если свалится одна из команд, рухнет и весь скрипт.
set -xe
#Создаем директорию для логов
mkdir -p /var/log/sausage-store/
#Разрешаем использование директории пользователю backend
sudo chown backend:backend /var/log/sausage-store/
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo rm -f /home/student/sausage-store.jar||true
#Переносим артефакт в нужную папку
curl -u "${NEXUS_REPO_USER}":"${NEXUS_REPO_PASS}" -o sausage-store.jar "${NEXUS_REPO_URL}"/"${NEXUS_REPO_BACKEND_NAME}"/com/yandex/practicum/devops/sausage-store/"${VERSION}"/sausage-store-"${VERSION}".jar
sudo cp ./sausage-store.jar /opt/sausage-store/bin/sausage-store-backend.jar||true #"<...>||true" говорит, если команда обвалится — продолжай
#Создаем файл .env с переменными
cd /home/student
rm .env
cat > .env << END
PSQL_DBNAME="${PSQL_DBNAME}"
PSQL_HOST="${PSQL_HOST}"
PSQL_PASSWORD="${PSQL_PASSWORD}"
PSQL_PORT="${PSQL_PORT}"
PSQL_USER="${PSQL_USER}"
MONGO_USER="${MONGO_USER}"
MONGO_PASSWORD="${MONGO_PASSWORD}"
MONGO_HOST="${MONGO_HOST}"
MONGO_PORT="${MONGO_PORT}"
MONGO_DATABASE="${MONGO_DATABASE}"
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD}
END
sudo chown backend:backend .env
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl enable sausage-store-backend
sudo systemctl restart sausage-store-backend