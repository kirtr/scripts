#!/bin/sh
lxc launch ubuntu:19.10 wp
container_up_check.sh wp
lxc file push install_wordpress.sh wp/home/ubuntu/
lxc exec wp -- su --login ubuntu -c "sudo ./install_wordpress.sh"
#lxc exec wp -- sudo -u ubuntu sh -c /home/ubuntu/amulet_build.sh
