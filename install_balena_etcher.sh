#Add Etcher debian repository:

echo add source to apt
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
echo

echo Trust Bintray.com GPG key:
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
echo

echo Update and install:
sudo apt-get update
sudo apt-get install balena-etcher-electron
echo
