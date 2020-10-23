#!/bin/sh
set -e

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <path/to/rootfs.tar.gz> <path/to/sdcard/mnt>"
    exit 1
fi

# Path to rootfs tar file.
src_rootfs=$1
# Path to mount point.
dest=$2

# Extracting $src_rootfs to temporary directory."
mkdir -p temp
tar -xf $src_rootfs -C temp

# Syncing new $src_rootfs to sdcard.
sudo rsync -av --delete --progress temp/ $dest && sync

echo "Cleaning up."
rm -rf temp
