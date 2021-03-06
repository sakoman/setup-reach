#!/bin/bash

set -e

SRCREV_POKY=1cab405d88149fd63322a867c6adb4a80ba68db3
SRCREV_OE=6094ae18c8a35e5cc9998ac39869390d7f3bb1e2
SRCREV_FREESCALE=9704df97f08cf5895e2f5bcfb33f1a53d10c7704
SRCREV_FREESCALE_DISTRO=771fb6d4c0c9530083fcc8c5452270bb9b3915ba
SRCREV_REACH=df8893debb152d400e5ab7ca4b386ac29a4ec2a8
SRCREV_QT5=201fcf27cf07d60b7d6ab89c7dcefe2190217745
SRCREV_MENDER=b411e6078e7bffece46b7ebb64cbb8062a15ef46

if [ "X$1" = "Xhelp" ]; then
	echo ""
	echo "Usage: $0 <dlss_dir>"
	echo "   dlss_dir: directory to place downloads and sstate-cache"
	echo "             (ommit for yocto default)"
	exit 1;
fi

if [ -z "$1" ]; then
	my_dlss="default"
else
	my_dlss=$1
fi

echo "Removing previous installation"
rm -rf sources
rm -rf build

mkdir sources

echo "Cloning poky"
git clone git://git.yoctoproject.org/poky sources/poky
if [[ $SRCREV_POKY != "auto" ]]; then
	cd sources/poky
	git checkout $SRCREV_POKY
	cd ../..
fi

echo "Cloning meta-openembedded"
git clone git://git.openembedded.org/meta-openembedded sources/meta-openembedded
if [[ $SRCREV_OE != "auto" ]]; then
	cd sources/meta-openembedded
	git checkout $SRCREV_OE
	cd ../..
fi

echo "Cloning meta-freescale"
git clone git://git.yoctoproject.org/meta-freescale sources/meta-freescale
if [[ $SRCREV_FREESCALE != "auto" ]]; then
	cd sources/meta-freescale
	git checkout $SRCREV_FREESCALE
	cd ../..
fi

echo "Cloning meta-freescale-distro"
git clone git@github.com:Freescale/meta-freescale-distro.git sources/meta-freescale-distro
if [[ $SRCREV_FREESCALE_DISTRO != "auto" ]]; then
	cd sources/meta-freescale-distro
	git checkout $SRCREV_FREESCALE_DISTRO
	cd ../..
fi

echo "Cloning meta-reach"
git clone https://github.com/jmore-reachtech/meta-reach.git sources/meta-reach
if [[ $SRCREV_REACH != "auto" ]]; then
	cd sources/meta-reach
	git checkout $SRCREV_REACH
	cd ../..
fi

echo "Cloning meta-qt5"
git clone https://github.com/meta-qt5/meta-qt5.git sources/meta-qt5
if [[ $SRCREV_QT5 != "auto" ]]; then
	cd sources/meta-qt5
	git checkout $SRCREV_QT5
	cd ../..
fi

echo "Cloning meta-mender"
git clone https://github.com/mendersoftware/meta-mender.git sources/meta-mender
if [[ $SRCREV_MENDER != "auto" ]]; then
	cd sources/meta-mender
	git checkout $SRCREV_MENDER
	cd ../..
fi

set build

pwd
TEMPLATECONF=../meta-reach/conf/sample/ source sources/poky/oe-init-build-env >> /dev/null

if [ "X$my_dlss" = "Xdefault" ]; then
	echo "Using default download and sstate directories"
else
	echo DL_DIR ?= \""$my_dlss"/downloads\" >> conf/local.conf
	echo SSTATE_DIR ?= \""$my_dlss/sstate-cache"\" >> conf/local.conf
fi
