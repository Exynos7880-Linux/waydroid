#!/bin/bash
ARCH="arm64"
SYSTEM_DOWNLOAD_URL=`python3 getlatest.py system ${ARCH}`
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

# check if unzip installed or not
if [ ! -f "/usr/bin/unzip" ] ; then
  echo unzip missing, installing.
  pkcon install unzip -y
fi

if [ ! -f "/usr/share/waydroid-extra/images/system.img" ] ; then
  echo "Downloading Waydroid Images"
  curl "${SYSTEM_DOWNLOAD_URL}" -o system.zip
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
waydroid init -f

if [ ! -e /home/waydroid ] ; then
  echo "exiting"
  exit
fi

echo "copying misc files"
cp -rf anbox-hybris.conf /etc/gbinder.d/anbox-hybris.conf
cp -rf disabled_services.rc /usr/libexec/droid-hybris/system/etc/init/disabled_services.rc
cp -f config_nodes /home/waydroid/lxc/waydroid/config_nodes

echo "rebooting..."
reboot
