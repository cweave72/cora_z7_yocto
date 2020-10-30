# Building the Cora-z7 Yocto image

This repository provides the workspace for building the Yocto Linux image for the Digilent Cora Z7-10.

## Steps:

### Clone the repo:
```
$ git clone https://github.com/cweave72/cora_z7_yocto.git
$ cd cora_z7_yocto
$ git submodule update --init
```

### Initializing the build environment:
```
$ . init_build.sh
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
