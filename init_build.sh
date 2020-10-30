#!/bin/bash

# This script must be sourced.
#
TEMPLATECONF=$(pwd)/meta-cora-z7-base/conf/template 
source poky/oe-init-build-env build

DL_DIR="$HOME/netshare/yocto_dl"
SSTATE_DIR="$HOME/netshare/yocto_sstate"
# IMPORTANT:  TMPDIR cannot be on a network shared drive
TMPDIR="$HOME/yocto/tmp"

LOCAL_CONF=conf/local.conf

sed -i 's@\(^TMPDIR = \).*@\1"'"$TMPDIR"'"@' $LOCAL_CONF
sed -i 's@\(^DL_DIR = \).*@\1"'"$DL_DIR"'"@' $LOCAL_CONF
sed -i 's@\(^SSTATE_DIR = \).*@\1"'"$SSTATE_DIR"'"@' $LOCAL_CONF
