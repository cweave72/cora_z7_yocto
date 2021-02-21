# Building the Cora-z7 Yocto image

This repository provides the workspace for building an example Yocto Linux image for the Digilent Cora Z7-10.

## Steps:

### Clone the repo:
```
$ git clone https://github.com/cweave72/cora_z7_yocto.git
$ cd cora_z7_yocto
$ git submodule update --init
```

### Using a docker container to build.

See https://github.com/cweave72/yocto_docker for a Ubuntu image for yocto builds.

### Initializing the build environment using the `init_build.sh` script:
```
$ . init_build.sh -h
Script to initialize Yocto configuration (must be sourced).
Usage:
. init_build.sh [OPTIONS]
Options:
    -h --help         : Prints this message.
    --dl_dir=PATH     : Path to desired DL_DIR location.
    --sstate=PATH     : Path to desired SSTATE_DIR location.
    --tmpdir=PATH     : Path to desired TMPDIR location (must not be a network share).

Example
$ . init_build.sh --dl_dir=tmp/yocto_dl --sstate=tmp/yocto_sstate --tmpdir=tmp/yocto_tmp
```

### Building the image:
Minimal image:
```
bitbake core-image-minimal
```
Example custom image (adds ssh, python, and a few others...):
```
bitbake coraz7-image-base
```

### Preparing the SD card

- Create two partitions:
    - `$ fdisk /dev/sdb` (or `/dev/mmcblk0`)
    - Boot partition:
        - size something around 100M
    - rootfs partition
        - rest of space on card
- Format the partitions
    - `$ mkfs.vfat -F 32 -n boot /dev/sdb1` (or `/dev/mmcblk0p1`)
    - `$ mkfs.ext4 -L root /dev/sdb2` (or `/dev/mmcblk0p2`)
- Mount sdcard
    - `$ mkdir -p ~/sdcard/{boot,rootfs}`   (creates directory for mounting)
    - `$ sudo mount -t vfat /dev/sdb1 ~/sdcard/boot` (or mmcblk0p1)
    - `$ sudo mount /dev/sdb2 ~/sdcard/rootfs` (or mmcblk0p1)
- Copy boot files found in $TMPDIR/deploy/images/cora-zynq7/ to sdcard/boot/
    - Files needed to boot:
    ```
    boot.bin
    fpga.bin
    system-top.dtb
    u-boot.img
    uEnv.txt
    uImage
    ```
- Extract rootfs to sdcard partition (in deploy/images/cora-zynq7/)
    - `$ tar xf coraz7-image-base-cora-zynq7.tar.gz -C ~/sdcard/rootfs`
- Unmount the sdcard
    - `$ sync`
    - `$ umount ~/sdcard/boot ~/sdcard/rootfs`
- Insert the sdcard and run.

## Connecting to the board.

The meta-cora-z7-base layer provides for an eth0 dhcp interface. You can connect via serial via:
```
minicom -b115200 -D/dev/ttyUSB1
```
Once you know the ip address assigned, you can ssh via: `ssh root@<ip>`. The root login is passwordless.

## Useful bitbake commands:

|       Command                    |                     Use                                     |
|----------------------------------|-------------------------------------------------------------|
| `bitbake -e <recipe>`            | Introspect environment (use with `less`)                    | 
| `bitbake -c clean <recipe>`      | Cleans build outputs.                                       |
| `bitbake -c cleansstate <recipe>`| Cleans sstate for a recipe                                  |
| `bitbake -c cleanall <recipe>`   | Cleans everything for a rebuild (even sstate and download)  |
| `bitbake -g <recipe>`            | Show dependencies (look at .dot file)                       |
| `bitbake -k <recipe>`            | Ignore failures when building                               |
| `bitbake-layers show-layers`     | Shows layers                                                |
| `bitbake-layers show-appends`    | Shows appended recipes                                      |
