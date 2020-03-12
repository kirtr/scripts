#https://gist.github.com/beardedinbinary/79d7ad34f9980f0a4c23
#stop script on error
set -e

# show commands as we run them
set -x

echo Updating package lists
apt-get update
echo

echo Install Apache with php
apt-get install apache2 php php-mysql -qy
#service apache2 restart
echo

echo Install MySQL
apt-get install mysql-server pwgen -qy
echo

echo Create WordPress database user password
PASSWORD=$(pwgen -1)
echo $PASSWORD > wordpress_database_user_password.txt

echo Set up your WordPress Database
#mysql_secure_installation
mysql <<EOF
create database wordpress;
create user 'wordpress'@'localhost' identified by '$PASSWORD';
grant all on wordpress.* to 'wordpress'@'localhost';
flush privileges;
EOF

echo Download WordPress and extract it
#wget http://wordpress.org/latest.tar.gz
wget http://10.167.58.133/latest.tar.gz
tar xzf latest.tar.gz -C /var/www/html
echo

echo Create wp-config.php file
cd /var/www/html/wordpress
sed -e "s/database_name_here/wordpress/" -e "s/username_here/wordpress/" -e "s/password_here/"$PASSWORD"/" wp-config-sample.php > wp-config.php

# Grab our Salt Keys and stick in our file
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

echo Please access the WordPress website to finish the installation
