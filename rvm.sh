#!/bin/bash

# 42Bash-RVM by Spenser Jones
# 
# About: This script will install the latest stable release of RVM
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

#########################################
### Install prerequisites via apt-get ###
#########################################

install_dependencies "$BUILD_DEPENDENCIES zlib1g-dev"

###################
### Install RVM ###
###################

sudo bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
sudo usermod -a -G rvm spenser
source /etc/profile.d/rvm.sh

###########################################
### Confirm that RVM installed properly ###
###########################################

RVM_INSTALLED=`rvm version`
if [[ "$RVM_INSTALLED" =~ rvm\ ([0-9.]+) ]]; then
  echo "RVM has installed correctly."
else
  echo "RVM failed to install properly."
  exit 1
fi

#################################################
### Install Ruby 1.9.3, and set it as default ###
#################################################

rvmsudo rvm install 1.9.3
rvm --default use 1.9.3
rvm tools rvm-env ruby bash

############################################
### Confirm that Ruby installed properly ###
############################################

RUBY_INSTALLED=`ruby -v`
if [[ "$RUBY_INSTALLED" =~ ruby\ ([0-9.]+) ]]; then
  if [ ${BASH_REMATCH[1]} = "1.9.3" ]; then
    echo "Ruby has installed correctly."
  else
    echo "Ruby seems to have installed, but you appear to have an old version overriding it. Please remove the following file, and then run 'ruby -v' to confirm that it is now 1.9.3"
    which ruby
    exit 1
  fi
  
else
  echo "Ruby failed to install properly."
  exit 1
fi

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