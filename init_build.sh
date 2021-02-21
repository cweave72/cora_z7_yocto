#!/bin/bash

# This script must be sourced.
#
(return 0 2>/dev/null) || { echo "ERROR: Must source script."; exit 1; }


usage () {
    echo "Script to initialize Yocto configuration (must be sourced)."
    echo "Usage:"
    echo ". $(basename ${BASH_SOURCE[0]}) [OPTIONS]"
    echo "Options:"
    echo "    -h --help         : Prints this message."
    echo "    -p --printenv     : Prints env variables."
    echo "    --dl_dir=PATH     : Path to desired DL_DIR location."
    echo "    --sstate=PATH     : Path to desired SSTATE_DIR location."
    echo "    --tmpdir=PATH     : Path to desired TMPDIR location (must not be a network share)."
}

confirm () {
    while true; do
        read -p "Continue [y/n] (RET=y): " REPLY
        case $REPLY in
            [yY]) return 0 ;;
            [nN]) return 1 ;;
            "") return 0 ;;
            *) echo "Unrecognized"; return 1 ;;
        esac
    done
}

# File which hold build variables.
BUILD_ENV=settings.cfg

unset DL_DIR
unset SSTATE_DIR
unset TMPDIR

# Source env file if it exists to recall variable settings.
[[ -f "$BUILD_ENV" ]] && { echo "Sourcing $BUILD_ENV"; source "$BUILD_ENV"; }

# Defaults
DL_DIR="${DL_DIR:-$HOME/netshare/yocto_dl}"
SSTATE_DIR="${SSTATE_DIR:-$HOME/netshare/yocto_sstate}"
TMPDIR="${TMPDIR:-$HOME/yocto/tmp}" # IMPORTANT:  TMPDIR cant be on a network shared drive

printonly=0

for arg in "$@"; do
    case $arg in
        dl_dir=*|--dl_dir=*)
            DL_DIR="${arg#*=}"
            ;;
        sstate=*|--sstate=*)
            SSTATE_DIR="${arg#*=}"
            ;;
        tmpdir=*|--tmpdir=*)
            TMPDIR="${arg#*=}"
            ;;
        -p|--printenv)
            printonly=1
            ;;
        -h|--help)
            usage
            return 0
            ;;
        *)
            echo "Unrecognized option: $arg"
            usage
            return 1
            ;;
    esac
done

CONF=$(pwd)/cora-z7-base/meta-cora-z7-base/conf/template 

echo "Using settings:"
echo "---------------------"
echo "TEMPLATECONF=$CONF"
echo "DL_DIR=$DL_DIR"
echo "SSTATE_DIR=$SSTATE_DIR"
echo "TMPDIR=$TMPDIR"
echo "---------------------"

[[ "$printonly" == 1 ]] && return
confirm || return

# Write variables to file.
echo "DL_DIR=$DL_DIR" > $BUILD_ENV
echo "SSTATE_DIR=$SSTATE_DIR" >> $BUILD_ENV
echo "TMPDIR=$TMPDIR" >> $BUILD_ENV

TEMPLATECONF=$CONF source poky/oe-init-build-env build

LOCAL_CONF=conf/local.conf

# Update variables in local.conf with provided.
sed -i 's@\(^TMPDIR = \).*@\1"'"$TMPDIR"'"@' $LOCAL_CONF
sed -i 's@\(^DL_DIR = \).*@\1"'"$DL_DIR"'"@' $LOCAL_CONF
sed -i 's@\(^SSTATE_DIR = \).*@\1"'"$SSTATE_DIR"'"@' $LOCAL_CONF

echo "Done.  See $LOCAL_CONF."
