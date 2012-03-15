#!/bin/bash

# 42Bash-Git by Spenser Jones
# 
# About: This script will install the latest stable release of Git
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/git.sh)
# 2. Rejoice

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
    exit 0
  fi
  echo "You currently have Git $GIT_INSTALLED installed, and $GIT_VERSION is the newest. Updating now."
fi

#################################################
### Download the latest stable release of Git ###
#################################################

echo "Downloading & unpacking Git $GIT_VERSION"
curl http://git-core.googlecode.com/files/git-$GIT_VERSION.tar.gz | tar -xz

####################################
### Configuring and building Git ###
####################################

echo "Configuring, making, and installing Git $GIT_VERSION"
cd $TMP/git-$GIT_VERSION
./configure
make
sudo make install

############################
### Clean up and go home ###
############################

echo "Git has installed correctly. If the version below does not read $GIT_VERSION, please remove old version of git."
git --version
install_post $APPTMP