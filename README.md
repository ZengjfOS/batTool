# paxTool

## Help

运行Adan.bat脚本之后，可以执行如下命令

```
=========================================================
paxtool Help Info:
    0. 'exit': exit the bat program
    1. 'disverity': disable verity Android and auto reboot
    2. 'push': push file to Android
    3. 'pull': pull file from Android
    4. 'apk': install apk to Android
    5. 'root': set Android P adb with root/remount
    6. 'copy': copy Android build out file to flash/fs folder
    7. 'unlock': unlock the disable verity in u-boot
    8. 'open': auto exploer open dir
    9. 'log': auto pull /sdcard/debuglogger to log dir
=========================================================
```

如上帮助信息是脚本默认帮助，如果需要自己定义脚本帮助信息，请在Adan.bat同级目录创建help.txt，里面内容将会作为提示信息，默认帮助信息将无效；

## 命令说明

* disverity/reboot: 执行disable-verity，并重启，也可以当reboot用；
* push: 将fs目录下的文件推送到Android对应的位置；
* pull: 拷贝出Android文件；
* apk: 安装apk目录下的Android应用；
* root: 让adb工具进入root状态，重新挂载文件系统；
* copy: 拷贝Android编译输出文件到flash和fs目录，`.disable`后缀的文件将会被忽略拷贝，注意需要设置`copy/config.txt`文件，用来设置Android编译输出Samba路径；
* unlock: 解锁设备，使得设备可以disable-verity、remount；
* open: 自动打开`open/config.txt`指定的文件夹
* log: 自动pull /sdcard/debuglogger到log目录
 
## 依赖软件及驱动

`tools`目录有需要的工具软件:
* platform-tools_r28.0.1-windows.zip: adb工具包；
* latest_usb_driver_windows.zip: Android adb驱动；
* uuu.zip: mfgtool；

