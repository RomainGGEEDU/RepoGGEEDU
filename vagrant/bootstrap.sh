#!/usr/bin/env bash

echo "########### [1/] - System ########"
date > /etc/vagrant_provisioned_at
apt-get update
apt-get upgrade


echo "########### [2/] - Install MySQL (root/root) ######"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -y install mysql-server
apt-get -y install mysql-client
#mysql_secure_installation #http://www.woueb.net/2011/11/15/mysql-secure-installation/


echo "########### [3/] - Install Apache ######"
apt-get install -y apache2
if ! [ -L /var/www ]; then
  rm -rf /var/www/html/
  ln -fs /src /var/www/html
fi

echo "########### [4/] - Install PHP 7 #######"
apt-get install -y libapache2-mod-fastcgi
apt-get install -y php7.0
apt-get install -y php7.0-fpm
a2enmod actions fastcgi alias
systemctl restart apache2.service
service apache2 restart

echo "########### [5/] - Configuration ########"
#Permet de charger les variables d'environnement dans la partie PHP FPM
cp /src/vagrant/conf/www.conf /etc/php/7.0/fpm/pool.d/www.conf

#Permet de charger les variables d'environnements dans PHP FPM CLI
cp /src/vagrant/conf/studialis_cli_conf.sh /etc/profile.d/studialis_cli_conf.sh

cp /src/vagrant/conf/apache2.conf  /etc/apache2/apache2.conf
cp /src/vagrant/conf/000-default.conf /etc/apache2/sites-available/000-default.conf

/etc/init.d/php7.0-fpm restart
systemctl restart apache2.service
systemctl status apache2.service
service apache2 restart

#alias res='sudo systemctl restart apache2.service && sudo /etc/init.d/apache2 restart'

echo "########### [6/] - Server Module PHP7 ######"
apt-get -y install php7.0-mysql
apt-get install -y php7.0-gd
apt-get install -y php7.0-dev
apt-get install -y php7.0-curl
apt-get install -y php7.0-intl

systemctl reload php7.0-fpm.service


echo "########### [7/] - Utilitary ######"
apt-get install -y git
apt-get install -y drush
apt-get install -y dos2unix
apt-get install -y ruby
apt-get install -y ruby-pg
apt-get install -y libpq-dev
apt-get install -y ruby-dev
apt-get install -y vim
apt-get install -y zip unzip

echo "########### [8/] - Rewrite mod ########"
a2enmod rewrite
a2enmod proxy_fcgi
systemctl restart apache2.service
service apache2 restart
apache2ctl -M


echo "########### [9/] - Cookies & Confirmation page ########"
cp -r /src/vagrant/home/* /home/
#sudo git clone http://projet.si.oxymis.fr/git/drupal/confirmation_page /home/confirmation_page
service apache2 restart


echo "########### [10/] - Compass & Sass ########"
apt-get install -y ruby-full
apt-get install -y rubygems
gem install sass
gem install compass

echo "########### END - CONFIG SERVER ########"
