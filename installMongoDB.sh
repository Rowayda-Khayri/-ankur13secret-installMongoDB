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

    # to install php7 and all required components

    echo "Updating PHP repository"
    apt-get install python-software-properties build-essential -y > /dev/null
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y > /dev/null
    apt-get update > /dev/null

    echo "Installing PHP"
    sudo apt-get install php7.0 -y > /dev/null

    # PHP-APC is a free and open PHP opcode cacher for caching and optimizing PHP intermediate code, which helps to optimize the php page processing  
    echo "Installing PHP extensions"

    apt-get install curl php-pear php7.0-dev php7.0-zip php7.0-curl php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-xml php-apcu php-mongodb php7.0-cli php7.0-common php7.0-fpm -y > /dev/null

        

    # setting the value to zero to increase the security by processing th exact path and in more faster way
    echo "Setting Fix Path"
    sed -i 's|cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.0/fpm/php.ini
    sed -i 's|listen|listen = /var/run/php/php7.0-fpm.sock|g' /etc/php/7.0/fpm/pool.d/www.conf

    # configuring php7.0-mcrypt

    #check web server 

    if [[ $(which apache2) ]]
    then

        ln -s /etc/php/7.0/apache2/conf.d/mcrypt.ini /etc/php/7.0/mods-available/mcrypt.ini
        # enabling php7 mcrypt
        phpenmod mcrypt
    
    elif [[ $(which nginx) ]]
    then
        ln -s /etc/php/mods-available/mcrypt.ini /etc/php/7.0/fpm/conf.d/mcrypt.ini
        ln -s /etc/php/mods-available/mcrypt.ini /etc/php/7.0/cli/conf.d/mcrypt.ini

        # enabling php7 mcrypt
        phpenmod mcrypt

        # to restart the service
        service php7.0-fpm restart
    fi

    ########################## End PHP Installation ###########################
  
  
fi


########################## Mongo Installation ###########################


# to install MongoDB
echo "Installing MongoDB..."
  
# check PHP version

PHPVersion=$(php -r "echo PHP_VERSION;" | cut -c1-1);
currentVersion=${PHPVersion};

echo  $currentVersion;

if [ "$currentVersion" -eq "5" ]   # PHP 5
then

    if [[ $(which nginx) ]]
    then

        echo "extension=mongo.so" >> /etc/php5/fpm/php.ini
        apt-get install -y mongodb mongodb-server

        echo "Checking Mongo DB status..."
        service mongodb restart
        service mongodb status

        echo "Restarting Server"
        service nginx restart
        service php5-fpm restart

    elif [[ $(which apache2) ]]
    then

        echo "extension=mongo.so" >> /etc/php5/apache2/php.ini
        apt-get install -y mongodb mongodb-server

        echo "Checking Mongo DB status..."
        service mongodb restart
        service mongodb status

        echo "Restarting Server"
        service apache2 restart
        
    fi


elif [ "$currentVersion" -eq "7" ]    # PHP 7
then

    if [[ $(which nginx) ]]
    then

        echo "extension=mongo.so" >> /etc/php/7.0/fpm/php.ini
        apt-get install -y mongodb mongodb-server

        echo "Checking Mongo DB status..."
        service mongodb restart
        service mongodb status

        echo "Restarting Server"
        service nginx restart
        service php7.0-fpm restart

    elif [[ $(which apache2) ]]
    then

        echo "extension=mongo.so" >> /etc/php/7.0/apache2/php.ini
        apt-get install -y mongodb mongodb-server

        echo "Checking Mongo DB status..."
        service mongodb restart
        service mongodb status

        echo "Restarting Server"
        service apache2 restart
        
    fi
fi

########################## End Mongo Installation ###########################
  
echo "Congratulations... Mongo and PHP are installed on server."
echo "Thank you..." 
