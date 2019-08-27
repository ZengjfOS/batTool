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


# start combine for u-boot

UBOOT_BLOCKS=$((8 * 1024))
BOOTLOADER_IMG=output/bootloader.img

test -e ${BOOTLOADER_IMG} && rm ${BOOTLOADER_IMG}
sync

dd if=/dev/zero of=${BOOTLOADER_IMG} count=$UBOOT_BLOCKS bs=1024

# gpt
dd if=output/device-partitions.img of=${BOOTLOADER_IMG}
# uboot
dd if=u-boot/imx-boot-imx8qmmek-sd.bin of=${BOOTLOADER_IMG} conv=notrunc seek=32 bs=1K



