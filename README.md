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

## Partition type_guid

* 分区类型请参考：[Partition type GUIDs](https://en.wikipedia.org/wiki/GUID_Partition_Table)

## 使用说明

* [bpttool.sh](bpttool.sh)：用于合成gpt分区表。请将分区信息文件放入[partitions](partitions)目录，输出为[output](ouput)目录同名`.bpt`和`.img`文件；
* [mkbootimg.sh](mkbootimg.sh)：用于制作FAT32镜像包。请将需要放入FAT32镜像的文件放入[boot_files](boot_files)目录中，输出文件在[output](output)目录的`boot.img`文件；

## 分区扩展

* growpart 
* resize2fs
