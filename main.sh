#!/bin/bash

#update centos
sudo yum -y update

#install tools
sudo yum -y install wget git zip unzip vim nano 

#update timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
