#!/bin/bash

export USER="antthoma" #Set your user here
apt update
apt install ufw sudo cron vim libpam-pwquality net-tools -y
groupadd user42
usermod -aG user42 ${USER}
usermod -aG sudo ${USER}
