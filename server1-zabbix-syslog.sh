#!/bin/bash

echo "Развертка Zabbix Server"

echo "Установка Zabbix Server для server..."

sudo wget https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.4+debian12_all.deb
sudo dpkg -i zabbix-release_latest_7.4+debian12_all.deb
sudo apt-get update
sudo apt-get install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

echo "Копирование данных Zabbix Server..."
sudo cp zabbix_server.conf /etc/zabbix/zabbix_server.conf
sudo cp zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

echo "Установка и настройка MariaDB для server..."

sudo apt-get install rsync mariadb-server galera-4 -y

sudo mysql -uroot -p123 -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -p123 -e "create user zabbix@localhost identified by 'password';"
sudo mysql -uroot -p123 -e "grant all privileges on zabbix.* to zabbix@localhost;"
sudo mysql -uroot -p123 -e "set global log_bin_trust_function_creators = 0;"

#echo "Восстановление базы данных сервера..."

#sudo mysql -uroot -p zabbix < zabbix.SQL

echo "Настройка Galera для server1..."

sudo systemctl stop mariadb
sudo cp galera1.cnf /etc/mysql/conf.d/galera.cnf

echo "Запуск кластера и Zabbix server..."

sudo galera_new_cluster
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

echo "Установка и настройка Syslog-ng для server..."

sudo apt-get install syslog-ng -y
sudo cp syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
sudo mkdir -p /etc/syslog-ng/keys
sudo mkdir -p /etc/syslog-ng/keys/ca
sudo cp ca.crt /etc/syslog-ng/keys/ca
sudo cp server.crt /etc/syslog-ng/keys
sudo cp server.key /etc/syslog-ng/keys
sudo chown root:root /etc/syslog-ng/keys/ca/ca.crt
sudo chown root:root /etc/syslog-ng/keys/server.crt
sudo chown root:root /etc/syslog-ng/keys/server.key
sudo mkdir -p /var/log/_remote
sudo systemctl restart syslog-ng
sudo systemctl enable syslog-ng
