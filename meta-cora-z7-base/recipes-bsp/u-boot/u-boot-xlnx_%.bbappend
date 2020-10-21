
SRC_URI_append_cora-zynq7 = " \
               file://platform-top.h \
               file://zynq_coraz7_defconfig \
               file://zynq-coraz7.dts \
               file://zynq_coraz7.h \
               file://0001-libfdt-cleanup.patch \
               "
FILESEXTRAPATHS_prepend_cora-zynq7 := "${THISDIR}/files:"


#do_copy_arty-zynq7() {
do_configure_prepend_cora-zynq7() {
    cp ${S}/../zynq_coraz7_defconfig ${S}/configs/
    cp ${S}/../zynq-coraz7.dts ${S}/arch/arm/dts/
    cp ${S}/../zynq_coraz7.h ${S}/include/configs/
}
