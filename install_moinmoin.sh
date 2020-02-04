#!/bin/sh
#To install MoinMoin, run the following command in the command prompt:
echo "Installing apache and moinmoin"
apt install apache2 libapache2-mod-python python-moinmoin
a2enmod cgid.load

#To configure your first wiki application, please run the following set of commands. Let us assume that you are creating a wiki named mywiki:
echo "Creating directories and copying files"
mkdir /home/moinmoin
cd /usr/share/moin
cp -R data /home/moinmoin
cp -R underlay /home/moinmoin
cp server/moin.cgi /home/moinmoin

echo "Change ownership to the webserver"
sudo chown -R www-data:www-data /home/moinmoin
sudo chmod -R ug+rwX /home/moinmoin
sudo chmod -R o-rwx /home/moinmoin

#Now you should configure MoinMoin to find your new wiki mywiki. To configure MoinMoin, open /etc/moin/mywiki.py file and change the following line:
echo data_dir = '/home/moinmoin/data' >> /etc/moin/mywiki.py

#Also, below the data_dir option add the data_underlay_dir:
echo data_underlay_dir='/usr/share/moin/mywiki/underlay' >> /etc/moin/mywiki.py
exit

Probably need to get wsgi enabled
http://moinmo.in/MoinMoinDownload
http://master19.moinmo.in/InstallDocs
https://code.google.com/archive/p/modwsgi/wikis/ConfigurationGuidelines.wiki
http://moinmo.in/Documentation


