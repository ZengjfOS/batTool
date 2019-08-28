#!/bin/bash

HOME_PATH=`echo ~`

YOCTO_ROOT_PATH=mount/imx8-yocto-ga98
YOCTO_PROJCT=imx8-build-wayland
YOCTO_DPLOY_PATH=tmp/deploy/images/imx8qmmek

KERNER_ROOT_PATH=tmp/work-shared/imx8qmmek/kernel-source
IMAGE_PATH=arch/arm64/boot
DTS_PATH=arch/arm64/boot/dts/freescale

DTS_FILES=("fsl-imx8qm-mek-dom0.dtb")
IMAGE_FILES=("Image")
UBOOT_FILES=("imx-boot-imx8qmmek-sd.bin-flash_linux_m4")

help() {
	echo "USAGE:"
	echo "    cmd uboot"
	echo "    cmd kernel"
}

copy_dts() {
	for file in ${DTS_FILES[@]}; do
		DTS_FILE_PATH=${HOME_PATH}/${YOCTO_ROOT_PATH}/${YOCTO_PROJCT}/${KERNER_ROOT_PATH}/${DTS_PATH}/${file}
		cp ${DTS_FILE_PATH} boot_files/ -v
	done
}

copy_kernel() {
	# copy kernel file
	for file in ${IMAGE_FILES[@]}; do
		KERNEL_FILE_PATH=${HOME_PATH}/${YOCTO_ROOT_PATH}/${YOCTO_PROJCT}/${KERNER_ROOT_PATH}/${IMAGE_PATH}/${file}
		cp ${KERNEL_FILE_PATH} boot_files/ -v
	done
}

copy_uboot() {
	# copy u-boot file
	for file in ${UBOOT_FILES[@]}; do
		UBOOT_FILE_PATH=${HOME_PATH}/${YOCTO_ROOT_PATH}/${YOCTO_PROJCT}/${YOCTO_DPLOY_PATH}/${file}
		cp ${UBOOT_FILE_PATH} u-boot/ -v
	done
}

if [ $# -eq 0 ];then
	help
	exit -1
fi

while [ $# -gt 0 ]; do
	case $1 in
	"dts")
		copy_dts
		;;
	"uboot")
		copy_uboot
		;;
	"kernel")
		copy_kernel
		;;
	*)
		help
		;;
	esac

	shift
done
