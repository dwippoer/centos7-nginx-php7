#!/bin/bash
temp_dir="/tmp/install"
nginx_dir1="/etc/nginx"
nginx_dir2="/etc/nginx/conf.d"
vhost_dir="/home/vhost"
php_dir="/etc/opt/remi/php71"

#update centos
sudo yum -y update

#install tools
sudo yum -y install wget git zip unzip vim nano 

#update timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

#clone repo

#if [ -d $temp_dir ];
#then
#	sudo rm -rf $temp_dir && git clone https://github.com/dwippoer/cento7-nginx-php7.git $temp_dir;
#else
#	git clone https://github.com/dwippoer/centos7-nginx-php7.git;
#fi
if [ -d $temp_dir ];
then
	sudo rm -rf $temp_dir;
fi
git clone https://github.com/dwippoer/centos7-nginx-php7.git $temp_dir

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
sudo yum -y install php71-php-pecl-mysql php71-php-pecl-zip php71-php-mysqlnd php71-php-mcrypt php71-php-mbstring php71-php-json php71-php-gd php71 php71-php php71-php-cli php71-php-common php71-php-pecl-swoole php71-php-tidy php71-php-xml php71-php-xmlrpc php71-php-pecl-memcached php71-php-curl

sudo yum -y install php71-php-fpm

#start services
sudo systemctl start php71-php-fpm
sudo systemctl enable php71-php-fpm

#update php config
sudo su - root -c 'mv $php_dir/php.ini $php_dir/php.ini.ori && cp $temp_dir/php.ini $php_dir'

#check apache
uninstall_apache()
{
sudo systemctl status httpd
if [ $? = 0 ]; then
sudo systemctl stop httpd && sudo yum -y remove httpd;
fi
}
uninstall_apache

#reduce swappines
sudo su - root -c 'echo "5" > /proc/sys/vm/swappiness'

#set firewall
sudo su - root -c 'cp -f $temp_dir/iptables.rules /etc/iptables.rules'
sudo iptables -F
sudo iptables-restore < /etc/iptables.rules
sudo su - root -c 'echo "iptables-restore < /etc/iptables.rules" >> /etc/rc.local'

exit 0
