#!/bin/bash
clear
echo "INSTALL PRESTASHOP" 
echo "=================="



# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get -y install lamp-server^

a2enmod rewrite
add-apt-repository universe
apt-get -y install php libapache2-mod-php php-cli php-mysql php-mcrypt php-zip php-ldap php-curl php-gd php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap php-intl curl
service apache2 restart




# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then
	echo "Please enter the NAME of the new PrestaShop database! (example: database1)"
	read dbname
	echo "Please enter the PrestaShop database CHARACTER SET! (example: latin1, utf8, ...)"
	read charset
	echo "Creating new PrestaShop database..."
	mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
	echo "Database successfully created!"
	echo "Showing existing databases..."
	mysql -e "show databases;"
	echo ""
	echo "Please enter the NAME of the new PrestaShop database user! (example: user1)"
	read username
	echo "Please enter the PASSWORD for the new PrestaShop database user!"
	read userpass
	echo "Creating new user..."
	mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
	echo "User successfully created!"
	echo ""
	echo "Granting ALL privileges on ${dbname} to ${username}!"
	mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"
	echo "You're good now :)"
	
	
# If /root/.my.cnf doesn't exist then it'll ask for root password	
else
	echo "Please enter root user MySQL password!"
	read rootpasswd
	echo "Please enter the NAME of the new PrestaShop database! (example: database1)"
	read dbname
	echo "Please enter the PrestaShop database CHARACTER SET! (example: latin1, utf8, ...)"
	read charset
	echo "Creating new PrestaShop database..."
	mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
	echo "Database successfully created!"
	echo "Showing existing databases..."
	mysql -uroot -p${rootpasswd} -e "show databases;"
	echo ""
	echo "Please enter the NAME of the new PrestaShop database user! (example: user1)"
	read username
	echo "Please enter the PASSWORD for the new PrestaShop database user!"
	read userpass
	echo "Creating new user..."
	mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
	echo "User successfully created!"
	echo ""
	echo "Granting ALL privileges on ${dbname} to ${username}!"
	mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
	mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
	echo "You're good now :)"
	
fi


cd /var/www/html
rm index.html
wget https://download.prestashop.com/download/releases/prestashop_1.7.1.1.zip
unzip prestashop.zip
rm prestashop.zip
chown -R www-data:www-data ./*
