#!/bin/bash
temp_dir="/tmp/install"
nginx_dir1="/etc/nginx"
nginx_dir2="/etc/nginx/conf.d"
vhost_dir="/home/vhost"

#update centos
sudo yum -y update

#install tools
sudo yum -y install wget git zip unzip vim nano 

#update timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

#clone repo
if [ -d $temp_dir ];
then
	git clone https://github.com/dwippoer/centos7-nginx-php7.git $temp_dir;
else
	rm -rf $temp_dir && git clone https://github.com/dwippoer/cento7-nginx-php7.git $ temp_dir;
fi

#install epel & remi
sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#install nginx
sudo yum -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

#update nginx
vhost_conf()
{
	if [ -d $nginx_dir2 ];
	then
		sudo cp $temp_dir/vhost.conf $nginx_dir2;
	else
		sudo mkdir $nginx_dir2 && sudo cp $temp_dir/vhost.conf $nginx_dir2;
	fi
}
nginx_conf()
{
	sudo rm -f $nginx_dir1/nginx.conf && sudo cp $temp_dir/nginx.conf $nginx_dir1
}
vhost_conf
nginx_conf

#instal php7
sudo yum -y install 
