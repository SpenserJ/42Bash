#!/bin/bash

# 42Bash-Gem by Spenser Jones
# 
# About: This script will install the latest stable release of Gem
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/gem.sh)
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

set_tmp_directory 'gem'
install_pre $APPTMP

#########################################
### Install prerequisites via apt-get ###
#########################################

install_dependencies $BUILD_DEPENDENCIES

if [ ! `command -v ruby` ]; then
  read -p "We need to install Ruby before installing gem. Shall we do that now? [Y/n] "
  if [[ ${REPLY:0:1} = [Nn] ]]; then
    echo "Alright. Installation will terminate now."
    exit 1
  else
    bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/rvm.sh)
  fi
fi

################################################
### Look up the latest stable release of Gem ###
################################################

echo "Scraping Ruby Gem's website for the latest stable release number"
GEM_VERSION=$(curl -silent http://rubygems.org/pages/download | sed -n 's/.*<h3>v\([0-9.]*\).*/\1/p')

#################################################
### Download the latest stable release of Gem ###
#################################################

echo "Downloading & unpacking Gem $GEM_VERSION"
curl http://production.cf.rubygems.org/rubygems/rubygems-$GEM_VERSION.tgz | tar -xz

######################
### Installing Gem ###
######################

echo "Installing Gem $GIT_VERSION"
cd $APPTMP/rubygems-$GEM_VERSION
rvmsudo ruby setup.rb

############################################
### Confirm that Ruby installed properly ###
############################################

GEM_INSTALLED=`gem -v`
if [[ "$GEM_INSTALLED" != "$GEM_VERSION" ]]; then
  echo "Gem failed to install properly."
  exit 1
fi

############################
### Clean up and go home ###
############################

echo "Gem $GEM_INSTALLED installed correctly."
install_post $APPTMP

#####################################################################
### End of our while loop for safely ending execution prematurely ###
#####################################################################

break
done