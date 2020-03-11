#/bin/bash


#WP_DOMAIN is going to be the fully qualified domain name for your site, which an example is provided. You should also choose a strong password for your WP_ADMIN_PASSWORD
 
WP_DOMAIN="`hostname`.local"
WP_ADMIN_USERNAME="admin"
WP_ADMIN_PASSWORD=""
WP_ADMIN_EMAIL="no@spam.org"
WP_DB_NAME="wordpress"
WP_DB_USERNAME="wordpress"
WP_DB_PASSWORD=""
WP_PATH="/var/www/wordpress"
MYSQL_ROOT_PASSWORD=""

# Set a hostname
echo "Add a host entry"
echo "127.1.1.1 $WP_DOMAIN" | sudo tee -a /etc/hosts

echo "Updating packages"
sudo sed -i s/archive.ubuntu.com/mirror.pnl.gov/ /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y

#Software Dependencies now its time for us to install our software, for this we used nginx, PHP and MySQL. For those of you that prefer Apache, I will refer you to NGINX vs. Apache: Our View of a Decade-Old Question. For those of you who still prefer Apache, stay tuned for a future tutorial or refer to How To Install WordPress with LAMP on Ubuntu 16.04 .

#By default mysql-server is going to ask for the root password, and we automate that with debconf-set-selections.
 
echo "Installing Packages"
echo "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
sudo apt install -y --no-install-recommends nginx mysql-server php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-zip php7.2-curl
read -p "Press [Enter] key to continue..."

# Set up Wordpress site
echo "Setting up Wordpress"
sudo mkdir -p $WP_PATH/public $WP_PATH/logs

#and then we are going to create our config file for nginx, in this tutorial we use the tee command because later on, we are going to learn how to automate this process. if you prefer to edit this file by hand using a text editor, such as vim

sudo tee /etc/nginx/sites-available/$WP_DOMAIN <<EOF
server {
listen 80;
listen [::]:80;
server_name $WP_DOMAIN www.$WP_DOMAIN;

root $WP_PATH/public;
index index.php;

access_log $WP_PATH/logs/access.log;
error_log $WP_PATH/logs/error.log;

location / {
try_files \$uri \$uri/ /index.php?\$args;
}

location ~ \.php\$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/run/php/php7.2-fpm.sock;
}
}
EOF

#now we are going to make a [symlink](https://en.wikipedia.org/wiki/Symbolic_link) from our newly created file located at /etc/nginx/sites-available/$WP_DOMAIN to /etc/nginx/sites-enabled.

sudo ln -s /etc/nginx/sites-available/$WP_DOMAIN /etc/nginx/sites-enabled/

#let's test our configuration for errors

sudo nginx -t

#and then restart the systemd service

sudo service nginx restart


#Configure MySQL
#we are now going to create a user and database for wordpress

mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE USER '$WP_DB_USERNAME'@'localhost' IDENTIFIED BY '$WP_DB_PASSWORD';
CREATE DATABASE $WP_DB_NAME;
GRANT ALL ON $WP_DB_NAME.* TO '$WP_DB_USERNAME'@'localhost';
EOF

#ignore the warning that it is insecure to use passwords on the command line, and if you are curious on why that warning appears, refer to this post on serverfault.

#Installing WordPress: now that our system is configured for WordPress, we are ready to install it.

#let's start with recreating the directory that will contain our source code, with a new directory with the correct permissions, and then change our working directory to that directory

sudo rm -rf $WP_PATH/public/ # !!!
sudo mkdir -p $WP_PATH/public/
sudo chown -R $USER $WP_PATH/public/
cd $WP_PATH/public/

#now we will download WordPress with wget, unarchive it, and remove the archive

wget https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz --strip-components=1
rm latest.tar.gz

#we are now going to edit some configuration files using sed and echo
mv wp-config-sample.php wp-config.php
sed -i s/database_name_here/$WP_DB_NAME/ wp-config.php
sed -i s/username_here/$WP_DB_USERNAME/ wp-config.php
sed -i s/password_here/$WP_DB_PASSWORD/ wp-config.php
echo "define('FS_METHOD', 'direct');" >> wp-config.php

#next lets change the ownership back to www-data to the directory that our source code is located
sudo chown -R www-data:www-data $WP_PATH/public/

#finally we can update our username and password with a curl command
curl "http://$WP_DOMAIN/wp-admin/install.php?step=2" \
--data-urlencode "weblog_title=$WP_DOMAIN" \
--data-urlencode "user_name=$WP_ADMIN_USERNAME" \
--data-urlencode "admin_email=$WP_ADMIN_EMAIL" \
--data-urlencode "admin_password=$WP_ADMIN_PASSWORD" \
--data-urlencode "admin_password2=$WP_ADMIN_PASSWORD" \
--data-urlencode "pw_weak=1"

#or do it manually by navigating to the domain name that you have set up
#congratulations! you now have a working WordPress website!
