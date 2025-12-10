#!/bin/bash

echo "Производится настройка proxy"

echo "Настройка узлов сети..."
sudo cp hosts /etc/hosts

echo "Настройка имени узла..."
sudo hostnamectl set-hostname host-proxy

echo "Настройка интерфейсов..."
sudo ifdown enp0s3
sudo cp interfaces-p /etc/network/interfaces
sudo systemctl restart networking

echo "Настройка SSH..."
sudo apt-get update
sudo apt-get install openssh-server -y
sudo sed -i 's/^#\?Port.*/Port 22/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "Копирование данных SSH..."
sudo mkdir -p ~/.ssh
sudo cp authorized_keys ~/.ssh/

/bin/bash
