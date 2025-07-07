#!/bin/bash


if [ "$(id -u)" != "0" ]; then
    echo "Этот скрипт должен быть запущен с правами суперпользователя (sudo)" 1>&2
    exit 1
fi


GREEN='\033[0;32m'
NC='\033[0m' 

echo -e "${GREEN}=== Начинаем полное удаление Docker ===${NC}"


if [ -x "$(command -v docker)" ]; then
    docker stop $(docker ps -a -q) 2>/dev/null
    docker rm $(docker ps -a -q) 2>/dev/null
fi

apt-get purge -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
apt-get autoremove -y --purge
apt-get autoclean

rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -rf /etc/docker
rm -rf ~/.docker


rm -f /etc/apt/sources.list.d/docker.list

echo -e "${GREEN}=== Docker успешно удален ===${NC}"

echo -e "${GREEN}=== Начинаем установку актуальной версии Docker ===${NC}"


apt-get update
apt-get upgrade -y


apt-get install -y ca-certificates curl gnupg lsb-release


mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null


apt-get update


apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


docker --version
docker compose version

echo -e "${GREEN}=== Настройка Docker ===${NC}"


usermod -aG docker $SUDO_USER


systemctl enable docker
systemctl start docker


systemctl enable containerd
systemctl start containerd


systemctl status docker --no-pager
systemctl status containerd --no-pager


echo -e "${GREEN}=== Тестируем Docker ===${NC}"
docker run --rm hello-world

echo -e "${GREEN}=== Установка завершена! ===${NC}"
echo "Перезагрузите систему или выполните 'newgrp docker' для применения изменений прав группы"
echo "Теперь вы можете использовать Docker без sudo"
echo "Для проверки Docker Compose используйте: docker compose version"