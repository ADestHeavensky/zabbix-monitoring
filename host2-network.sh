#!/bin/bash

echo "Производится настройка второго узла"

echo "Настройка узлов сети..."
sudo cp hosts /etc/hosts

echo "Настройка имени узла..."
sudo hostnamectl set-hostname host2

echo "Настройка интерфейсов..."
sudo cp interfaces-h1 /etc/network/interfaces
sudo systemctl restart networking

echo "Настройка SSH..."
sudo apt-get update
sudo apt-get install openssh-server -y
sudo sed -i 's/^#\?Port.*/Port 22/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "Копирование данных SSH..."
sudo mkdir -p /root/.ssh
sudo cp authorized_keys /root/.ssh/

/bin/bash
