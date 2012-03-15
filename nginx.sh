#!/bin/bash

# 42Bash-Nginx by Spenser Jones
# 
# About: This script will install the latest stable release of Nginx
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/nginx.sh)
# 2. Rejoice

#######################################
### Load our general functions file ###
#######################################

source functions.sh

###############################
### If an error occurs, die ###
###############################

set -e

##############################################
### What /tmp directory do we want to use? ###
##############################################

if [ "$1" != "" ]; then
  TMP=${1%/}/nginx
else
  TMP=/tmp/42Bash-Nginx
fi

#########################################################
### Create a temporary directory for the source files ###
#########################################################

rm -rf $TMP
mkdir $TMP
cd $TMP

######################################
### Confirm that curl is installed ###
######################################

command -v curl >/dev/null || (echo "Installing curl..."; sudo apt-get -y install curl)

##################################################
### Look up the latest stable release of Nginx ###
##################################################

echo "Scraping Nginx' website for the latest stable release number"
NGINX_VERSION=$(curl -silent http://nginx.org/en/download.html | sed -n '/Stable version/ s/.*\([0-9].0.[0-9]*\)\.tar\.gz.*/\1/p')
echo "Current version of Nginx is $NGINX_VERSION"

###########################################################################
### Check if nginx is already installed, and if so, if it is up to date ###
###########################################################################

if [ `command -v nginx` ]; then
  echo "Due to limitations in how Nginx displays it's version number, we cannot automatically detect your version."
  nginx -v
  read -p "Does the above version match $NGINX_VERSION? [y/N] "
  [[ ${REPLY:0:1} = [Yy] ]] && exit
fi

#########################################
### Install prerequisites via apt-get ###
#########################################

install_dependencies 'build-essential autoconf gettext cmake libncurses5-dev libtool libssl-dev libpcre3-dev'

###########################
### Create the WWW user ###
###########################
id www >/dev/null 2>&1 || sudo useradd -MrUs /bin/false www

###################################################
### Download the latest stable release of Nginx ###
###################################################

echo "Downloading & unpacking Nginx $NGINX_VERSION"
curl http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar -xz

######################################
### Configuring and building Nginx ###
######################################

echo "Configuring, making, and installing Nginx $NGINX_VERSION"
cd $TMP/nginx-$NGINX_VERSION
./configure --with-http_ssl_module --user=www --group=www
make
sudo make install

###########################################################################
### Configuring configs, initializing startup scripts, and linking bins ###
###########################################################################

if [ -f /usr/local/nginx/sbin/nginx ]; then
  if [ ! -f /usr/local/sbin/nginx ]; then sudo ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx; fi
else
  echo "Something has gone horribly wrong with the Nginx install."
  exit
fi

############################
### Clean up and go home ###
############################

echo "Nginx has installed correctly. If the version below does not read $NGINX_VERSION, please remove old version of Nginx."
nginx -v
cd ~
rm -rf $TMP