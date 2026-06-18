#!/bin/bash

# Оновлюємо списки пакетів перед початком
echo "Оновлення списків пакетів..."
sudo apt update -y


# 1. ПЕРЕВІРКА ТА ВСТАНОВЛЕННЯ DOCKER
if command -v docker &> /dev/null;
then

echo "Docker вже встановлено: $(docker --version)"

else
echo "Docker не знайдено. Початок встановлення..."
sudo apt install -y docker.io

fi

# 2. ПЕРЕВІРКА ТА ВСТАНОВЛЕННЯ DOCKER COMPOSE
if command -v docker-compose &> /dev/null;
then

echo "Docker-compose вже встановлено: $(docker-compose --version)"

else
echo "Docker-compose не знайдено. Початок встановлення..."
sudo apt install -y docker-compose

fi

# 3. ПЕРЕВІРКА ТА ВСТАНОВЛЕННЯ PYTHON 3
if command -v python3 &> /dev/null && command -v pip3 &> /dev/null && python3 -c "import venv" &> /dev/null;
then

echo "Python 3, pip3 та venv вже встановлено: $(python3 --version)"

else
echo "Компоненти Python знайдено не повністю. Початок встановлення..."
sudo apt install -y python3 python3-pip python3-venv

fi



# 4. ПЕРЕВІРКА ТА ВСТАНОВЛЕННЯ DJANGO
if python3 -c "import django" &> /dev/null; 
then

echo "Django вже встановлено: $(python3 -m django --version)"

else

echo "Django не знайдено. Встановлення через pip..."

pip3 install django --break-system-packages

fi


echo "Всі інструменти успішно встановлено!"

