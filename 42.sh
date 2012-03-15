#!/bin/bash

# 42Bash by Spenser Jones
# 
# About: This script will install git, nginx, passenger, ChiliProject, gitosis, and BigTuna (eventually)
#
# Instructions:
#
# 1. bash <(curl -s https://raw.github.com/SpenserJ/42Bash/master/42.sh)
# 2. Rejoice

#######################################
### Load our general functions file ###
#######################################

[ $FUNCTIONS_LOADED ] || source <(curl -s https://raw.github.com/SpenserJ/42Bash/master/functions.sh)

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
install_pre $TMP

#################################
### Proceed with installation ###
#################################

[ $GIT ]          && source <(curl -s https://raw.github.com/SpenserJ/42Bash/master/git.sh)
[ $NGINX ]        && source <(curl -s https://raw.github.com/SpenserJ/42Bash/master/nginx.sh)

############################
### Clean up and go home ###
############################

install_post $TMP