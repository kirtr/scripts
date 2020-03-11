#/bin/bash


echo "Updating sources"
sudo sed -i s/archive.ubuntu.com/us.archive.ubuntu.com/ /etc/apt/sources.list
sudo apt update
echo

echo "Installing dependencies"
sudo apt install -y python3.7 python3.7-dev python3.7-venv python3-pip
echo

echo "Clone the project"
git clone https://github.com/Amulet-Team/Amulet-Map-Editor
echo

echo "Change the working directory to be the directory created when cloning"
cd Amulet-Map-Editor
echo

echo "Create a virtual environment"
python3.7 -m venv ENV
echo

echo "Activate the environment"
source ENV/bin/activate
echo

echo "Install the requirements"
pip3 install wheel cython
pip3 install -r requirements.txt
echo
