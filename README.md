# README

## 参考文档

* [eMMC 简介](https://linux.codingbelief.com/zh/storage/flash_memory/emmc/)
  * [eMMC 分区管理](https://linux.codingbelief.com/zh/storage/flash_memory/emmc/emmc_partitions.html)
* [MBR与GPT](https://zhuanlan.zhihu.com/p/26098509)
* [android img的sparse和ext4格式](https://blog.csdn.net/js_wawayu/article/details/52420255)
  * img2simg rootfs.ext4 rootfs.ext4.img
* [uuu docs](https://github.com/NXPmicro/mfgtools/wiki/Example)
  * FB: flash -raw2sparse fs rootfs.ext4
  * FB: flash fs rootfs.ext4.img
* [YOCTO copy file to rootfs](https://github.com/ZengjfOS/Yocto/blob/master/docs/0015_copy_file_to_rootfs.md)

## Partition type_guid

* 分区类型请参考：[Partition type GUIDs](https://en.wikipedia.org/wiki/GUID_Partition_Table)

## 使用说明

* [bpttool.sh](bpttool.sh)：用于合成gpt分区表。请将分区信息文件放入[partitions](partitions)目录，输出为[output](ouput)目录同名`.bpt`和`.img`文件；
* [mkbootimg.sh](mkbootimg.sh)：
  * 生成FAT32镜像包。请将需要放入FAT32镜像的文件放入[boot_files](boot_files)目录中，输出文件在[output](output)目录的`boot.img`文件；
  * 生成bootloader.img，包含GPT分区和U-Boot。请将U-Boot放入`u-boot`目录，名称为`imx-boot-imx8qmmek-sd.bin`；

## 分区扩展

* growpart 
* resize2fs

##  uuu.list

```
uuu_version 1.1.29
#uuu scripts for imx8qm revB board Android imx_pi9.0 sd card
CFG: FB: -vid 0x1fc9 -pid 0x0129
#SDPS: boot -f uuu-u-boot-imx8qm.imx
SDPS: boot -f flash.bin
FB[-t 10000]: ucmd mmc rescan
FB[-t 10000]: ucmd mmc list
FB[-t 10000]: ucmd mmc info
FB[-t 10000]: ucmd setenv mmcdev 1
FB[-t 10000]: ucmd setenv fastboot_dev mmc
FB[-t 10000]: ucmd mmc dev 1
FB[-t 10000]: ucmd mmc info

#FB: ucmd mmc partconf 0 0 1 0

FB[-t 600000]: flash gpt device-partitions.img
FB: flash -raw2sparse all bootloader.img

FB[-t 600000]: flash boot boot.img
FB[-t 600000]: flash fs core-image-minimal-imx8qmmek-20180822022530.rootfs.ext4.img

# erase environment variables of uboot
# FB: ucmd mmc erase 0x2000 0x10

# FB: flash -raw2sparse all fsl-image-qt5-validation-imx-imx8qmmek.rootfs.sdcard
FB: done
```