#!/bin/bash

# 42Bash-Git by Spenser Jones
# 
# About: This script will install the latest stable release of Git
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/git.sh)
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

set_tmp_directory 'git'
install_pre $APPTMP

################################################
### Look up the latest stable release of Git ###
################################################

echo "Scraping Git's website for the latest stable release number"
GIT_VERSION=$(curl -silent http://git-scm.com/ | sed -n '/id="ver"/ s/.*v\([0-9].*\)<.*/\1/p')

#########################################################################
### Check if git is already installed, and if so, if it is up to date ###
#########################################################################

if [ `command -v git` ]; then
  GIT_INSTALLED=`git --version`
  GIT_INSTALLED=${GIT_INSTALLED#git version }
  if [ $GIT_INSTALLED = $GIT_VERSION ]; then
    echo "Git is already installed ($GIT_INSTALLED) and up to date ($GIT_VERSION)."
    break
  fi
  echo "You currently have Git $GIT_INSTALLED installed, and $GIT_VERSION is the newest. Updating now."
fi

#########################################
### Install prerequisites via apt-get ###
#########################################

install_dependencies "$BUILD_DEPENDENCIES zlib1g-dev"

#################################################
### Download the latest stable release of Git ###
#################################################

echo "Downloading & unpacking Git $GIT_VERSION"
curl http://git-core.googlecode.com/files/git-$GIT_VERSION.tar.gz | tar -xz

####################################
### Configuring and building Git ###
####################################

echo "Configuring, making, and installing Git $GIT_VERSION"
cd $APPTMP/git-$GIT_VERSION
./configure
make
sudo make install

############################
### Clean up and go home ###
############################

GIT_INSTALLED=`git --version`
GIT_INSTALLED=${GIT_INSTALLED#git version }
if [ $GIT_INSTALLED = $GIT_VERSION ]; then
  echo "Git has installed correctly."
else
  echo "Git seems to have installed, but you appear to have an old version overriding it. Please remove the following file, and then run 'git --version' to confirm that it is now $GIT_VERSION"
  which git
  exit 1
fi
install_post $APPTMP

#####################################################################
### End of our while loop for safely ending execution prematurely ###
#####################################################################

break
done