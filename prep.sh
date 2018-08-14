#!/bin/bash
# Prepare a deployment for Lwaxana Installation
# This is the firstrun script which simply installs the needed repositories

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root" 2>&1
  exit 1
else

  project=lwaxana
  if [[ ! -d /etc/baldnerd ]]; then
    mkdir /etc/baldnered
  fi
  echo $project > /etc/baldnerd/project

  apt update

  apt install --yes git screen dialog gnupg nano apt-utils

  # Setup default account info
  git config --global user.email "robbie@baldnerd.com"
  git config --global user.name "Robbie Ferguson"

  cd /root
  mkdir $project
  cd $project

  git clone https://github.com/Cat5TV/$project-admin

  cd /root/$project/$project-admin

  # Configure default locale
  apt install -y locales
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LC_TIME=en_US.UTF-8
  if grep -q "# en_US.UTF-8" /etc/locale.gen; then
    /bin/sed -i -- 's,# en_US.UTF-8,en_US.UTF-8,g' /etc/locale.gen
  fi
  locale-gen
  #dpkg-reconfigure locales # Set second screen to UTF8

  # Make it so SSH does not load the locale from the connecting machine (causes problems on Pine64)
  # This requires the user to re-connect
  sed -i -e 's/    SendEnv LANG LC_*/#   SendEnv LANG LC_*/g' /etc/ssh/ssh_config

  echo System Prepped... re-connect, run screen, then /root/$project/$project-admin/build.sh
fi
