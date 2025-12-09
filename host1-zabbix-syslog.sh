#!/bin/bash

echo "Установка Zabbix Agent для host1..."

sudo wget https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.4+debian12_all.deb
sudo dpkg -i zabbix-release_latest_7.4+debian12_all.deb
sudo apt-get update
sudo apt-get install -y zabbix-agent
sudo cp zabbix_agentd1.conf /etc/zabbix/zabbix_agentd.conf
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

echo "Установка и настройка Syslog-ng для host1..."

sudo apt-get install syslog-ng -y
sudo cp syslog-ng1.conf /etc/syslog-ng/syslog-ng.conf
sudo mkdir -p /etc/syslog-ng/keys
sudo mkdir -p /etc/syslog-ng/keys/ca
sudo cp ca.crt /etc/syslog-ng/keys/ca
sudo cp host1.crt /etc/syslog-ng/keys
sudo cp host1.key /etc/syslog-ng/keys
sudo chown root:root /etc/syslog-ng/keys/ca/ca.crt
sudo chown root:root /etc/syslog-ng/keys/host1.crt
sudo chown root:root /etc/syslog-ng/keys/host1.key
sudo ln -s /etc/syslog-ng/certs/ca.crt /etc/syslog-ng/certs/4e83bfff.0

sudo systemctl restart syslog-ng
sudo systemctl enable syslog-ng
