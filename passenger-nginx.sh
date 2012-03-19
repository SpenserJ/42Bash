#!/bin/bash

# 42Bash-Passenger-Nginx by Spenser Jones
# 
# About: This script will install the latest stable release of Passenger for Nginx
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/passenger-nginx.sh)
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

set_tmp_directory 'passenger-nginx'
install_pre $APPTMP

#########################################
### Install prerequisites via apt-get ###
#########################################

install_dependencies "$BUILD_DEPENDENCIES libssl-dev libpcre3-dev"

if [ ! `command -v gem` ]; then
  read -p "We need to install Gem before installing Passenger. Shall we do that now? [Y/n] "
  if [[ ${REPLY:0:1} = [Nn] ]]; then
    echo "Alright. Installation will terminate now."
    exit 1
  else
    bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/gem.sh)
  fi
fi

#########################
### Install Passenger ###
#########################

rvmsudo gem install passenger

#################################################
### Confirm that Passenger installed properly ###
#################################################

if [ ! `command -v passenger-install-nginx-module` ]]; then
  echo "Passenger failed to install properly."
  exit 1
fi

##################################################
### Look up the latest stable release of Nginx ###
##################################################

echo "Scraping Nginx' website for the latest stable release number"
NGINX_VERSION=$(curl -silent http://nginx.org/en/download.html | sed -n '/Stable version/ s/.*\([0-9].0.[0-9]*\)\.tar\.gz.*/\1/p')
echo "Current version of Nginx is $NGINX_VERSION"

###################################################
### Download the latest stable release of Nginx ###
###################################################

echo "Downloading & unpacking Nginx $NGINX_VERSION"
curl http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar -xz

#############################################
### Run the Passenger for Nginx installer ###
#############################################

passenger-install-nginx-module --auto --prefix=/usr/local --nginx-source-dir=$APPTMP/nginx-$NGINX_VERSION --extra-configure-flags='--with-http_ssl_module --user=www --group=www'

############################
### Clean up and go home ###
############################

echo "Passenger for Nginx installed correctly."
install_post $APPTMP

#####################################################################
### End of our while loop for safely ending execution prematurely ###
#####################################################################

break
done