#!/bin/bash

# 42Bash-Git by Spenser Jones
# 
# About: This script will install the latest stable release of Git
#
# Instructions:
#
# 1. bash < <(curl -s https://raw.github.com/SpenserJ/42Bash/master/git.sh)
# 2. Rejoice

###############################
### If an error occurs, die ###
###############################
set -e

##############################################
### What /tmp directory do we want to use? ###
##############################################

if [ "$1" != "" ]; then
  TMP=${1%/}/git
else
  TMP=/tmp/42Bash-Git
fi

#########################################################
### Create a temporary directory for the source files ###
#########################################################

rm -rf $TMP
mkdir $TMP
cd $TMP

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
  if [ ${GIT_INSTALLED#git version } = $GIT_VERSION ]; then
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
cd ~
rm -rf $TMP