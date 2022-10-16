#!/bin/bash

if [[ $1 = "vanilla" ]]; then
  FLAVOUR="VANILLA"
elif [[ $1 = "gapps" ]]; then
  FLAVOUR="GAPPS"
else [[ $1 != "" ]];
  echo "USAGE: waydroid.sh vanilla|gapps"
  exit 1
fi

ARCH="arm64"
SYSTEM_DOWNLOAD_URL=`python3 getlatest.py system ${ARCH} ${FLAVOUR}`
IMG_DIR=/usr/share/waydroid-extra/images/

if [ ! -f /usr/bin/waydroid ] ; then
  echo "Adding chum repo"
  ssu ar sailfishos-chum https://repo.sailfishos.org/obs/sailfishos:/chum/4.4.0.72_aarch64/
  ssu er sailfishos-chum
  echo "Installing Waydroid"
  pkcon refresh
  pkcon install -y waydroid waydroid-runner
fi

if [ ! -e "${IMG_DIR}" ] ; then
  echo "${IMG_DIR}"
  mkdir -p "${IMG_DIR}"
fi

# check if wget installed or not
if [ ! -f "/usr/bin/wget" ] ; then
  echo unzip missing, installing.
  pkcon install unzip wget -y
fi

if [ ! -f "/usr/share/waydroid-extra/images/system.img" ] ; then
  echo "Downloading Waydroid ${FLAVOUR} Images"
  wget "${SYSTEM_DOWNLOAD_URL}" -O system.zip
  unzip system.zip -d "${IMG_DIR}"
  rm system.zip
fi

if [ ! -f "/usr/share/waydroid-extra/images/vendor.img" ] ; then
  echo "Extracting vendor.zip"
  unzip vendor.zip -d "${IMG_DIR}"
  rm vendor.zip
fi

echo "running waydroid init"
rm -rf /var/lib/waydroid /home/waydroid ~/waydroid /home/defaultuser/.share/waydroid /home/defaultuser/.local/share/applications/*aydroid* /home/defaultuser/.local/share/waydroid
mkdir -p /home/waydroid
ln -sf /home/waydroid /var/lib/waydroid
waydroid init -f

if [ ! -d /var/lib/waydroid/ ] ; then
  echo "exiting.."
  exit
else
  echo "rebootig.."
  reboot
fi
