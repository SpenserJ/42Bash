#!/bin/bash

# 42Bash-Git by Spenser Jones
# 
# About: This script will install the latest stable release of Git
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/rvm.sh)
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

set_tmp_directory 'rvm'
install_pre $APPTMP

######################################################
### Install RVM, Ruby 1.9.3, and set it as default ###
######################################################

sudo bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
sudo usermod -a -G rvm spenser
source /etc/profile.d/rvm.sh
rvm install 1.9.3
rvm --default use 1.9.3
rvm tools rvm-env ruby bash

############################
### Clean up and go home ###
############################

echo "RVM and Ruby 1.9.3 have installed correctly."
install_post $APPTMP

#####################################################################
### End of our while loop for safely ending execution prematurely ###
#####################################################################

break
done