#!/bin/sh
lxc launch images:debian/buster debian
lxc file push install_wordpress.sh debian/root/
lxc exec wp -- su -c ./install_wordpress.sh
#lxc exec wp -- sudo -u ubuntu sh -c /home/ubuntu/amulet_build.sh
