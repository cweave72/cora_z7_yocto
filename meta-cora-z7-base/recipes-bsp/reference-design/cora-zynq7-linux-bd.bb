SUMMARY = "The reference design for cora-zynq7-linux-bd"
DESCRIPTION = "Contains the Reference Design Files and hardware software \
hand-off file. The HDF provides bitstream and Xilinx ps7_init_gpl.c/h \
platform headers."
SECTION = "bsp"

DEPENDS += "unzip-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

COMPATIBLE_MACHINE = "cora-zynq7"

HW_BD = "linux_bd"

FILESEXTRAPATHS_prepend := "${THISDIR}/cora-zynq7:"
SRC_URI = " \
           file://system.hdf \
           file://fpga-bit-to-bin.py \
           "

S = "${WORKDIR}"
HDF = "system.hdf"
PROVIDES = "virtual/bitstream virtual/xilinx-platform-init"

FILES_${PN}-platform-init += "${PLATFORM_INIT_DIR}/*"
FILES_${PN}-platform-init += "${base_libdir}/firmware/*"

FILES_${PN}-bitstream += " \
		fpga.bit \
        fpga.bin \
		"

PACKAGES = "${PN}-platform-init ${PN}-bitstream"

BITSTREAM ?= "fpga-${PV}-${PR}.bin"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit xilinx-platform-init
inherit deploy

SYSROOT_DIRS += "${PLATFORM_INIT_DIR} ${base_libdir}/firmware"

do_install() {
	fn=$(unzip -l ${S}/${HDF} | awk '{print $NF}' | grep ".bit$")
	unzip -o ${S}/${HDF} ${fn} -d ${D}
	[ "${fn}" == "fpga.bit" ] || mv ${D}/${fn} ${D}/fpga.bit

	install -d ${D}${PLATFORM_INIT_DIR}
	for fn in ${PLATFORM_INIT_FILES}; do
		unzip -o ${S}/${HDF} ${fn} -d ${D}${PLATFORM_INIT_DIR}
	done

    install -d ${D}${base_libdir}/firmware
    cp ${S}/${HDF} ${D}${base_libdir}/firmware/system.hdf

    python ${S}/fpga-bit-to-bin.py -f ${D}/fpga.bit ${D}/fpga.bin
}

do_deploy () {
	if [ -e ${D}/fpga.bit ]; then
		install -d ${DEPLOYDIR}
		install -m 0644 ${D}/fpga.bin ${DEPLOYDIR}/${BITSTREAM}
		ln -sf ${BITSTREAM} ${DEPLOYDIR}/fpga.bin
	fi
}
addtask deploy before do_build after do_install
