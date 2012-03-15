###############################
### If an error occurs, die ###
###############################

set -e

##################################################
### Check for and install missing dependencies ###
##################################################

install_dependencies() {
  IFS=' ' read -ra DEPENDENCY <<< "$1"
  MISSING=''
  for i in "${DEPENDENCY[@]}"; do
    STATUS=`dpkg-query -W -f='${Status}' $i`
    if [[ "$STATUS" == *not-installed ]]; then
      MISSING="$MISSING$i "
    fi
  done
  if [ ! -z "$MISSING" ]; then
    echo "Installing dependencies - $MISSING"
    sudo apt-get -y install $MISSING
  fi
}

set_tmp_directory() {
  [ -z "$1" ] && (echo "Please pass set_tmp_directory an application name"; exit)
  if [ -z $TMP ]; then
    APPTMP=/tmp/42Bash-$1
  else
    APPTMP=$TMP/$1
  fi
}

install_pre() {
  rm -rf $1
  mkdir $1
  cd $1
}

install_post() {
  cd ~
  rm -rf $1
}

############################################
### Mark this functions script as loaded ###
############################################

FUNCTIONS_LOADED=true