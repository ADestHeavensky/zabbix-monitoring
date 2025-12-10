#!/bin/bash

echo "Производится настройка первого сервера"

echo "Настройка узлов сети..."
sudo cp hosts /etc/hosts

echo "Настройка имени узла..."
sudo hostnamectl set-hostname server

echo "Настройка интерфейсов..."
sudo cp interfaces /etc/network/interfaces
sudo systemctl restart networking

echo "Включение пересылки пакетов..."
sudo sed -i 's/^#\?net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p

echo "Настройка маскарадинга..."
sudo apt-get update
sudo apt-get install iptables -y
sudo iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o enp0s3 -j MASQUERADE
sudo sudo apt-get install iptables-persistent -y

echo "Настройка SSH..."
sudo apt-get install openssh-server -y
sudo sed -i 's/^#\?Port.*/Port 22/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "Копирование данных SSH..."
sudo mkdir -p ~/.ssh
sudo cp id_rsa ~/.ssh/
sudo cp id_rsa.pub ~/.ssh/
sudo touch ~/.ssh/known_hosts
sudo chown vboxuser:vboxuser ~/.ssh/known_hosts

/bin/bash
