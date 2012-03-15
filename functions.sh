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