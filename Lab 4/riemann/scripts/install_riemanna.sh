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
sudo wget https://github.com/riemann/riemann/releases/download/0.3.2/riemann_0.3.2_all.deb
sudo dpkg -i riemann_0.3.2_all.deb

sudo apt-get -y install leiningen
sudo git clone https://github.com/samn/riemann-syntax-check.git
cd riemann-syntax-check
sudo lein uberjar

cd ~
sudo git clone git://github.com/riemann/riemann.git
cd riemann
lein repl :connect 127.0.0.1:5557


sudo cat << EOF >> /etc/hosts
192.168.1.110 riemanna riemanna.example.com
192.168.1.120 riemannb riemannb.example.com
192.168.1.100 riemannmc riemannmc.example.com
192.168.1.210 graphitea graphitea.example.com
192.168.1.220 graphiteb graphiteb.example.com
192.168.1.200 graphitemc graphitemc.example.com
192.168.1.111 hosta hosta.example.com
192.168.1.121 hostb hostb.example.com
192.168.1.101 hostmc hostmc.example.com
192.168.1.201 logstasha logstasha.example.com
192.168.1.202 esa1 esa1.example.com
192.168.1.203 esa2 esa2.example.com
192.168.1.204 esa3 esa3.example.com
EOF

sudo gem install riemann-tools
sudo hostnamectl set-hostname riemanna

sudo cp /tmp/configs/riemann/riemann.config /etc/riemann/riemann.config
sudo cp /tmp/configs/riemann/examplecom/etc/email.clj /etc/riemann/examplecom/etc/email.clj
sudo cp /tmp/configs/riemann/examplecom/etc/graphitea.clj /etc/riemann/examplecom/etc/graphitea.clj
sudo cp /tmp/configs/riemann/examplecom/etc/checks.clj /etc/riemann/examplecom/etc/checks.clj
sudo cp /tmp/configs/riemann/examplecom/etc/collectd.clj /etc/riemann/examplecom/etc/collectd.clj

sudo  systemctl reload riemann

ufw allow 60000:61000/tcp

systemctl reload riemann
