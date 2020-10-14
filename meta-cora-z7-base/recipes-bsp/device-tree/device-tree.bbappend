FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# device tree sources for Cora z7
COMPATIBLE_MACHINE_cora-zynq7 = ".*"
SRC_URI_append_cora-zynq7 = " \
    file://pcw.dtsi \
    file://system-user.dtsi \
    file://system-top.dts \
    "
