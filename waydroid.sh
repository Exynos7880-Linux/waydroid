#!/bin/bash
SYSTEM_DOWNLOAD_URL=https://netix.dl.sourceforge.net/project/waydroid/images/system/lineage/waydroid_arm64/lineage-17.1-20220723-VANILLA-waydroid_arm64-system.zip
VENDOR_DOWNLOAD_URL=
IMG_DIR=/usr/share/waydroid-extra/images/

echo "Adding chum repo"
ssu ar sailfishos-chum https://repo.sailfishos.org/obs/sailfishos:/chum/4.4.0.72_aarch64/
ssu er sailfishos-chum

echo "Installing Waydroid"
pkcon refresh
pkcon install -y waydroid waydroid-runner

echo "Downloading Waydroid Images"
curl "${SYSTEM_DOWNLOAD_URL}" -O system.zip
curl "${VENDOR_DOWNLOAD_URL}" -O vendor.zip

echo "Extracting Images"
mkdir -p "${IMG_DIR}"
unzip system.zip -d "${IMG_DIR}"
unzip vendor.zip -d "${IMG_DIR}"
rm system.zip vendor.zip

echo "running waydroid init"
waydroid init -f

echo "copying misc files"
cp -rf anbox-hybris.conf /etc/gbinder.d/anbox-hybris.conf
cp -rf disabled_services.rc /usr/libexec/droid-hybris/system/etc/init/disabled_services.rc

echo "rebooting..."
reboot
