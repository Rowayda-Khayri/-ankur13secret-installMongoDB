#!/usr/bin/env bash

echo "Written By Ankur Mishra"
echo "Starting Server Setup....."
echo "Be Sure you are a super user..."

# To become a super user
sudo su

# to update the packages from repositories
apt-get update

# to install or upgrade package necessary to upgrade
apt-get dist-upgrade

# check if php is installed

if [[ $(which php) ]]  #php is already installed
then
    echo "PHP is already installed.."

else   #php isn't installed

    ########################## PHP Installation ###########################

    #install PHP
    # to install php5 and all required components
    echo "Updating PHP repository"
    apt-get install python-software-properties build-essential -y > /dev/null
    add-apt-repository ppa:ondrej/php5 -y > /dev/null
    apt-get update > /dev/null

    echo "Installing PHP"
    apt-get install php5-common php5-dev php5-cli php5-fpm -y > /dev/null

    # PHP-APC is a free and open PHP opcode cacher for caching and optimizing PHP intermediate code, which helps to optimize the php page processing  
    echo "Installing PHP extensions"
    apt-get install curl php5-curl php5-gd php5-mcrypt php-apc php-pear php5-dev php5-mongo -y > /dev/null

    # setting the value to zero to increase the security by processing th exact path and in more faster way
    echo "Setting Fix Path"
    sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
    sed -i 's/listen/listen = /var/run/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf

    # configuring php5-mcrypt
    ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/mcrypt.ini

    # enabling php5 mcrypt
    php5enmod mcrypt

    # to restart the service
    service php5-fpm restart

    ########################## End PHP Installation ###########################
  
fi


########################## Mongo Installation ###########################


# to install MongoDB
echo "Installing Mongo DB"
  echo "extension=mongo.so" >> /etc/php5/fpm/php.ini
  apt-get install -y mongodb mongodb-server

echo "Checking Mongo DB status..."
 service mongod restart
 service mongod status

echo "Restarting Server"
  service nginx restart
  service php5-fpm restart
  

########################## End Mongo Installation ###########################

echo "Congratulations... Mongo and PHP is installed on server."
echo "Thankyou..."