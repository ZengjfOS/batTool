# README

## Help

运行Adan.bat脚本之后，可以执行如下命令

```
=========================================================
Adan_XEN Help Info:
    0. 'exit': exit the bat program
    1. 'flash uk': flash uboot/kernel to board
    2. 'flash all': flash all file to board
    3. 'xen': standard(default) or xen mode
=========================================================
```

如上帮助信息是脚本默认帮助，如果需要自己定义脚本帮助信息，请在Adan.bat同级目录创建help.txt，里面内容将会作为提示信息，默认帮助信息将无效；

## 命令说明

* flash uk(flash uboot/kernel): 在flash目录放入相应的烧录内容，将自动执行烧录uboot/kernel部分；
* flash all: 在flash目录放入相应的烧录内容，将自动执行烧录，烧录完整的的Linux系统；
* xen: 烧录程序是标准程序还是xen程序；
 
## 依赖软件及驱动

`tools`目录有需要的工具软件:
* platform-tools_r28.0.1-windows.zip: adb工具包；
* latest_usb_driver_windows.zip: Android adb驱动；
* uuu.zip: mfgtool；

