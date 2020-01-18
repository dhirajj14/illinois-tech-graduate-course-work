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

wget https://github.com/riemann/riemann/releases/download/0.3.2/riemann-0.3.2-1.noarch.rpm
sudo rpm -Uvh riemann-0.3.2-1.noarch.rpm

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

sudo hostnamectl set-hostname riemannb

sudo cp /tmp/configs/riemann/riemann.config /etc/riemann/riemann.config
sudo cp /tmp/configs/riemann/examplecom/etc/email.clj /etc/riemann/examplecom/etc/
sudo cp /tmp/configs/riemann/examplecom/etc/graphitea.clj /etc/riemann/examplecom/etc/
sudo cp /tmp/configs/riemann/examplecom/etc/checks.clj /etc/riemann/examplecom/etc/
sudo cp /tmp/configs/riemann/examplecom/etc/collectd.clj /etc/riemann/examplecom/etc/

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=5000-6000/tcp
sudo firewall-cmd --reload

sudo chkconfig riemann on

