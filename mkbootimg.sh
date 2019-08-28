#!/bin/bash

# IMG_TYPE="-F 32"
BOOT_BLOCKS=$(((65535 * 512) / 512))
echo "BOOT_BLOCKS: $BOOT_BLOCKS"

rm output/boot.img
sync
mkfs.vfat -n "BOOT" -S 512 ${IMG_TYPE} -C output/boot.img $BOOT_BLOCKS


if [ ! -a "${HOME}/.mtoolsrc" ]; then
    echo "mtools_skip_check=1" > ${HOME}/.mtoolsrc
    # echo "please check install mtools and ${HOME}/.mtoolsrc exist."
fi

for file in ./boot_files/*; do
    if test -f ${file}; then
        file_name=`basename ${file}`
    
        if [ ! "${file_name}" == "empty" ]; then
            echo "mcopy -i output/boot.img -s ${file} ::${file_name}"
            mcopy -i output/boot.img -s ${file} ::${file_name}
        fi 

    fi
done

echo start generate gpt
./bpttool.sh
echo end generate gpt

# start combine for u-boot
UBOOT_BLOCKS=$((8 * 1024))
# uboot
# dd if=u-boot/imx-boot-imx8qmmek-sd.bin of=${BOOTLOADER_IMG} conv=notrunc seek=32 bs=1K

STD_UBOOT_FILE=imx-boot-imx8qmmek-sd.bin-flash_linux_m4
XEN_UBOOT_FILE=u-boot-imx8qm-xen-dom0.imx

for file in ./u-boot/*; do
    if test -f ${file}; then
        file_name=`basename ${file}`
    
        if [ ! "${file_name}" == "empty" ]; then
            BOOTLOADER_IMG=
            if [ "$file_name" == "${STD_UBOOT_FILE}" ]; then
                BOOTLOADER_IMG=output/bootloader.img
            elif [ "$file_name" == "${XEN_UBOOT_FILE}" ]; then
                BOOTLOADER_IMG=output/bootloader-xen.img
            fi
            
            # just support 2 type u-boot
            if [ "${BOOTLOADER_IMG}" == "" ]; then
                continue
            fi

            test -f ${BOOTLOADER_IMG} && rm ${BOOTLOADER_IMG}
            sync
            echo "${BOOTLOADER_IMG}"

            dd if=/dev/zero of=${BOOTLOADER_IMG} count=$UBOOT_BLOCKS bs=1024
            # gpt
            dd if=output/device-partitions.img of=${BOOTLOADER_IMG}

            # uboot
            if [ "$file_name" == "${STD_UBOOT_FILE}" ]; then
                dd if=u-boot/${STD_UBOOT_FILE} of=${BOOTLOADER_IMG} conv=notrunc seek=32 bs=1K
            elif [ "$file_name" == "${XEN_UBOOT_FILE}" ]; then
                dd if=u-boot/${XEN_UBOOT_FILE} of=${BOOTLOADER_IMG} conv=notrunc seek=32 bs=1K
            fi
        fi 

    fi
done

