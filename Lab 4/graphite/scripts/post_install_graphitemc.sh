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
192.168.1.110 riemanna riemanna.example.com
192.168.1.120 riemannb riemannb.example.com
192.168.1.100 riemannmc riemannmc.example.com
192.168.1.210 graphitea graphitea.example.com
192.168.1.220 graphiteb graphiteb.example.com
192.168.1.200 graphitemc graphitemc.example.com
192.168.1.310 hosta hosta.example.com
192.168.1.320 hostb hostb.example.com
192.168.1.300 hostmc hostmc.example.com
EOF

sudo apt-get update
wget https://dl.grafana.com/oss/release/grafana_6.3.5_amd64.deb
sudo dpkg -i grafana_6.3.5_amd64.deb

sudo apt-get install -y apt-transport-https grafana

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install graphite-carbon
sudo apt-get -y install graphite-api
cd ~
sudo hostnamectl set-hostname graphitemc
sudo cp /tmp/configs/graphite/carbona.conf /etc/carbon/carbon.conf
sudo cp /tmp/configs/graphite/storageschemas.conf /etc/carbon/
sudo touch /etc/carbon/storage-aggregation.conf

wget https://raw.githubusercontent.com/jamtur01/aom-code/master/4/graphite/carbon-cache-ubuntu.init
sudo cp carbon-cache-ubuntu.init /etc/init.d/carbon-cache
sudo chmod 0755 /etc/init.d/carbon-cache
sudo update-rc.d carbon-cache defaults

sudo cat << EOF >> /etc/default/graphite-carbon
CARBON_CACHE_ENABLED=true
RELAY_INSTANCES=1
CACHE_INSTANCES=2
EOF

#sudo service carbon-relay start
#sudo service carbon-cache start
sudo cp /tmp/configs/graphite/carbon-cache@.service /lib/systemd/system/
sudo cp /tmp/configs/graphite/carbon-relay@.service /lib/systemd/system/

sudo systemctl enable carbon-cache@1.service
sudo systemctl enable carbon-cache@2.service
#sudo systemctl start carbon-cache@1.service
#sudo systemctl start carbon-cache@2.service

sudo systemctl enable carbon-relay@1.service
#sudo systemctl start carbon-relay@1.service

#sudo rm -f /lib/systemd/system/carbon-relay.service
#sudo rm -f /lib/systemd/system/carbon-cache.service

sudo cp /tmp/configs/graphite/graphite-api.yaml /etc/

sudo apt-get -y install gunicorn3
sudo touch /var/lib/graphite/api_search_index
sudo chown _graphite:_graphite /var/lib/graphite/api_search_index
#sudo service graphite-api start
sudo cp /tmp/configs/graphite/graphite-api.service /lib/systemd/system/

sudo systemctl enable graphite-api.service
#sudo systemctl start graphite-api.service

sudo service grafana-server start
ufw allow 60000:61000/tcp
