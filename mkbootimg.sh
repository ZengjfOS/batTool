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
