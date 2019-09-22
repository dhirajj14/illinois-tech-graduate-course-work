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
192.168.0.110 riemanna riemanna.example.com
192.168.0.120 riemannb riemannb.example.com
192.168.0.100 riemannmc riemannmc.example.com
192.168.0.210 graphitea graphitea.example.com
192.168.0.220 graphiteb graphiteb.example.com
192.168.0.200 graphitemc graphitemc.example.com
EOF

sudo apt-get update
wget https://dl.grafana.com/oss/release/grafana_6.3.5_amd64.deb
sudo dpkg -i grafana_6.3.5_amd64.deb

sudo apt-get install -y apt-transport-https grafana

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install graphite-carbon
sudo apt-get -y install graphite-api

sudo hostnamectl set-hostname graphitea

ufw allow 60000:61000/tcp
