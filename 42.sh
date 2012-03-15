#!/bin/bash

# 42Bash by Spenser Jones
# 
# About: This script will install git, nginx, passenger, ChiliProject, gitosis, and BigTuna (eventually)
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/42.sh)
# 2. Rejoice

###############################
### If an error occurs, die ###
###############################
set -e

##################################
### Ask what we should install ###
##################################

read -p "Install Git? [Y/n] "
[[ ${REPLY:0:1} = [Nn] ]] && GIT=false || GIT=true

read -p "Install Nginx? [Y/n] "
[[ ${REPLY:0:1} = [Nn] ]] && NGINX=false || NGINX=true

#########################################################
### Create a temporary directory for the source files ###
#########################################################

TMP=/tmp/42Bash
rm -rf $TMP
mkdir -p $TMP
cd $TMP

#################################
### Proceed with installation ###
#################################

if $GIT; then bash -s $TMP < <(curl -s https://raw.github.com/SpenserJ/42Bash/master/git.sh); fi
if $NGINX; then source /home/spenser/nginx.sh; fi
#bash -s $TMP < <(curl -s https://raw.github.com/SpenserJ/42Bash/master/nginx.sh); fi

############################
### Clean up and go home ###
############################
cd ~
rm -rf $TMP