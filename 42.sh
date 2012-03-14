#!/bin/bash

# 42Bash by Spenser Jones
# 
# About: This script will install git, nginx, passenger, ChiliProject, gitosis, and BigTuna (eventually)
#
# Instructions:
#
# 1. bash -s stable < <(curl -s https://raw.github.com/SpenserJ/42Bash/master/42.sh)
# 2. Rejoice

###############################
### If an error occurs, die ###
###############################
set -e

##################################
### Ask what we should install ###
##################################

read -p "Install Git? [Y/n] "
[[ ${REPLY:0:1} = [Yy] ]] && GIT=true || GIT=false

#########################################################
### Create a temporary directory for the source files ###
#########################################################

TMP=/tmp/42Bash
rm -rf $TMP
mkdir -p $TMP
cd $TMP

###################
### Install Git ###
###################

if $GIT; then bash -s $TMP < <(curl -s https://raw.github.com/SpenserJ/42Bash/master/git.sh); fi

############################
### Clean up and go home ###
############################
cd ~
rm -rf $TMP