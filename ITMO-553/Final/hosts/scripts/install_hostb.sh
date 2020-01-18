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


sudo cat << EOF >> /etc/hosts
192.168.2.100  prometheus prometheus.example.com
192.168.2.200 grafana grafana.example.com
192.168.2.210 hosta hosta.example.com
192.168.2.220 hostb hostb.example.com
EOF

sudo hostnamectl set-hostname hostb

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


sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=9100/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9090/tcp --permanent
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --reload


