# batTool

## Help

运行Adan.bat脚本之后，可以执行如下命令

```
=========================================================
Adan Help Info:
    0. 'exit': exit the bat program
    1. 'disverity': disable verity Android P and auto reboot
    2. 'push': push file to Android P
    3. 'pull': pull file from Android P
    4. 'flash uk': flash uboot/kernel to board
    5. 'flash all': flash all file to board
    6. 'flash all diserase': flash all file to board with no erase data partition
    7. 'apk': install apk to board
    8. 'root': set Android P adb with root/remount/setenforce 0
    9. 'copy': copy Android build out file to flash/fs folder
    10. 'xen': standard(default) or xen mode
=========================================================
```

如上帮助信息是脚本默认帮助，如果需要自己定义脚本帮助信息，请在Adan.bat同级目录创建help.txt，里面内容将会作为提示信息，默认帮助信息将无效；

## 命令说明

* disverity/reboot: 执行disable-verity，并重启，也可以当reboot用；
* push: 将fs目录下的文件推送到Android P对应的位置；
* pull: 拷贝出Android P文件；
* flash uk(flash uboot/kernel): 在flash目录放入相应的烧录内容，将自动执行烧录uboot/kernel部分；
* flash all: 在flash目录放入相应的烧录内容，将自动执行烧录，烧录完整的的Android P；
* flash all no erase: 在flash目录放入相应的烧录内容，将自动执行烧录，烧录完整的的Android P，但不擦除用户数据区；
* apk: 安装apk目录下的Android应用；
* root: 让adb工具进入root状态，重新挂载文件系统，关闭SELinux；
* copy: 拷贝Android编译输出文件到flash和fs目录，`.disable`后缀的文件将会被忽略拷贝，注意需要设置`copy/config.txt`文件，用来设置Android编译输出Samba路径；
* xen: 烧录程序是标准程序还是xen程序；
 
## 依赖软件及驱动

`tools`目录有需要的工具软件:
* platform-tools_r28.0.1-windows.zip: adb工具包；
* latest_usb_driver_windows.zip: Android adb驱动；
* uuu.zip: mfgtool；

