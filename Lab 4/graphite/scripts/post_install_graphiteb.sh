#!/bin/bash 
set -e
set -v


# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
# http://chrisbalmer.io/vagrant/2015/07/02/build-rhel-centos-7-vagrant-box.html
# Read this bug track to see why this line below was the source of a lot of trouble.... 
# https://github.com/mitchellh/vagrant/issues/1482
#echo "Defaults requiretty" | sudo tee -a /etc/sudoers.d/init-users
# Need to add this first as wget not part of the base package...
sudo yum install -y wget
#################################################################################################################
# code needed to allow for vagrant to function seamlessly
#################################################################################################################
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys

#########################
# Add customization here
#########################

# Install Elrepo - The Community Enterprise Linux Repository (ELRepo)
# https://wiki.centos.org/AdditionalResources/Repositories
sudo yum install -y epel-release 

# Install base dependencies -  Centos 7 mininal needs the EPEL repo in the line above and the package daemonize
sudo yum update -y
sudo yum install -y wget unzip vim git python-setuptools curl
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2


echo "All Done!"

sudo yum install -y java-1.8.0-openjdk
sudo yum -y install ruby ruby-devel gcc libxml2-devel
wget https://rpmfind.net/linux/epel/6/x86_64/Packages/d/daemonize-1.7.3-1.el6.x86_64.rpm
sudo rpm -Uvh daemonize-1.7.3-1.el6.x86_64.rpm

wget https://dl.grafana.com/oss/release/grafana-6.3.5-1.x86_64.rpm
sudo yum -y localinstall grafana-6.3.5-1.x86_64.rpm
sudo yum -y install gcc openssl-devel bzip2-devel libffi libffi-devel
cd /usr/src
wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz
sudo tar xzf Python-3.6.9.tgz
cd Python-3.6.9
sudo ./configure --enable-optimizations
sudo make altinstall
sudo rm /usr/src/Python-3.6.9.tgz
sudo cat << EOF >> /etc/hosts
192.168.0.110 riemanna riemanna.example.com
192.168.0.120 riemannb riemannb.example.com
192.168.0.100 riemannmc riemannmc.example.com
192.168.0.210 graphitea graphitea.example.com
192.168.0.220 graphiteb graphiteb.example.com
192.168.0.200 graphitemc graphitemc.example.com
EOF


sudo yum install -y python-setuptools
sudo yum install -y python-whisper python-carbon

sudo yum install -y python-pip gcc libffi-devel cairo-devel libtool libyaml-devel python-devel

sudo pip install --upgrade pip
sudo pip install -U six pyparsing websocket urllib3
sudo pip install graphite-api gunicorn3
sudo yum install grafana

sudo hostnamectl set-hostname graphiteb

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=5000-6000/tcp
sudo firewall-cmd --reload

