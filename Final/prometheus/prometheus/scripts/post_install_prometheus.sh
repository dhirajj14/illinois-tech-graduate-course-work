#!/bin/bash 
set -e
set -v


# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant


# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
echo "All Done!"

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime = 600/bantime = -1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

##################################################
# Add User customizations below here
##################################################

sudo apt-get install -y openjdk-8-jre
sudo apt-get -y install ruby ruby-dev build-essential zlib1g-dev

#Setting up the prometheus 
#Website Reference: https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04

#creating Users
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter

#create the necessary directories for storing Prometheus’ files and data
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

#set the user and group ownership on the new directories to the prometheus user.
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

cd ~

#downloading prometheus
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-amd64.tar.gz

#use the sha256sum command to generate a checksum of the downloaded file:
sha256sum prometheus-2.0.0.linux-amd64.tar.gz

#unpacking downloadecd file
tar xvf prometheus-2.0.0.linux-amd64.tar.gz

#coping unpack libraries to the local
sudo cp prometheus-2.0.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.0.0.linux-amd64/promtool /usr/local/bin/

#Set the user and group ownership on the binaries to the prometheus user created
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

#Copy the consoles and console_libraries directories to /etc/prometheus
sudo cp -r prometheus-2.0.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.0.0.linux-amd64/console_libraries /etc/prometheus

#setting users to directories
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries


#remove the leftover files from your home directory
rm -rf prometheus-2.0.0.linux-amd64.tar.gz prometheus-2.0.0.linux-amd64


#Configuring Prometheus and setting permisiion to file#
sudo cp /tmp/configs/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

sudo cp /tmp/configs/prometheus.service /etc/systemd/system/prometheus.service


#reloading daemon
sudo systemctl daemon-reload

#starting prometheus
sudo systemctl start prometheus

#enable service
sudo systemctl enable prometheus


###### Node Exporter #######
cd ~

##Downloading Node Exporter
curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.15.1/node_exporter-0.15.1.linux-amd64.tar.gz

#use the sha256sum command to generate a checksum of the downloaded file:
sha256sum node_exporter-0.15.1.linux-amd64.tar.gz

#unpacking downloadecd file
tar xvf node_exporter-0.15.1.linux-amd64.tar.gz


#coping unpack libraries to the local
sudo cp node_exporter-0.15.1.linux-amd64/node_exporter /usr/local/bin
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

#remove the leftover files from your home directory
rm -rf node_exporter-0.15.1.linux-amd64.tar.gz node_exporter-0.15.1.linux-amd64

#Configuring node exporter and setting permisiion to file#
sudo cp /tmp/configs/node_exporter.service /etc/systemd/system/node_exporter.service

#reloading daemon
sudo systemctl daemon-reload

#starting exporter
sudo systemctl start node_exporter

#enable service
sudo systemctl enable node_exporter

#restarting prometheus
sudo systemctl restart prometheus


sudo cat << EOF >> /etc/hosts
192.168.2.100  prometheus prometheus.example.com
192.168.2.200 grafana grafana.example.com
192.168.2.210 hosta hosta.example.com
192.168.2.220 hostb hostb.example.com
EOF



cd ~
sudo hostnamectl set-hostname prometheus


ufw allow 60000:61000/tcp
