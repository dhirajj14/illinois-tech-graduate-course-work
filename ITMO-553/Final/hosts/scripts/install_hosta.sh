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


sudo cat << EOF >> /etc/hosts
192.168.2.100  prometheus prometheus.example.com
192.168.2.200 grafana grafana.example.com
192.168.2.210 hosta hosta.example.com
192.168.2.220 hostb hostb.example.com
EOF



sudo apt-get update

sudo hostnamectl set-hostname hosta

###### Node Exporter #######
cd ~

#creating Users
sudo useradd --no-create-home --shell /bin/false node_exporter

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

ufw allow 60000:61000/tcp


