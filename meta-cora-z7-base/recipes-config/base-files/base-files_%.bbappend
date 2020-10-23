# Add files to the base-files recipe.

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://fstab \
    file://interfaces \
    file://aliases.sh \
    file://motd \
    "

do_install_append() {
    install -d ${D}/${sysconfdir}/network
    install -d ${D}/${sysconfdir}/profile.d
    install -D -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/
    install -D -m 0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/network/
    install -D -m 0644 ${WORKDIR}/motd ${D}${sysconfdir}/
    install -D -m 0644 ${WORKDIR}/aliases.sh ${D}${sysconfdir}/profile.d/
}
