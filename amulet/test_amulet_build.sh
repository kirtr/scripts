#!/bin/sh
lxc launch ubuntu: amulet
container_up_check.sh amulet
lxc file push amulet_build.sh amulet/home/ubuntu/
lxc exec amulet -- sudo -u ubuntu sh -c /home/ubuntu/amulet_build.sh
