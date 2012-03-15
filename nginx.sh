#!/bin/bash

# 42Bash-Nginx by Spenser Jones
# 
# About: This script will install the latest stable release of Nginx
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/nginx.sh)
# 2. Rejoice

#################################################################################
### While loop in case we need to cancel execution without killing the parent ###
#################################################################################

while true; do

#######################################
### Load our general functions file ###
#######################################

[ $FUNCTIONS_LOADED ] || source <(curl -s https://raw.github.com/SpenserJ/42Bash/master/functions.sh)

#################################
### Prepare the tmp directory ###
#################################

set_tmp_directory 'nginx'
install_pre $APPTMP

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
  [[ ${REPLY:0:1} = [Yy] ]] && break
fi

#########################################
### Install prerequisites via apt-get ###
#########################################

install_dependencies "$BUILD_DEPENDENCIES libssl-dev libpcre3-dev"

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
cd $APPTMP/nginx-$NGINX_VERSION
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
  exit 1
fi

############################
### Clean up and go home ###
############################

echo "Nginx has installed correctly. If the version below does not read $NGINX_VERSION, please remove old version of Nginx."
nginx -v
install_post $APPTMP

#####################################################################
### End of our while loop for safely ending execution prematurely ###
#####################################################################

done