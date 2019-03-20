# batTool

## Help

运行Adan.bat脚本之后，可以执行如下命令

```
=========================================================
Adan.bat Help Info:
    1. 'disverity' to disable verity Android P
    2. 'push' to push file to Android P
    3. 'flash uk' to flash uboot/kernel to board
    4. 'flash all' to flash all file to board
    5. 'flash all no erase' to flash all file to board with no erase data partition
    6. 'apk' to install apk to board
    7. 'exit' to exit the bat program
=========================================================
```

如上帮助信息是脚本默认帮助，如果需要自己定义脚本帮助信息，请在Adan.bat同级目录创建help.txt，里面内容将会作为提示信息，默认帮助信息将无效；

## 命令说明

* disverity: disable-verity；
* push: 将fs目录下的文件推送到Android P对应的位置；
* flash uk(flash uboot/kernel): 在flash目录放入响应的烧录内容，将自动执行烧录uboot/kernel部分；
* flash all: 在flash目录放入响应的烧录内容，将自动执行烧录，烧录完整的的Android P；
* flash all no erase: 在flash目录放入响应的烧录内容，将自动执行烧录，烧录完整的的Android P，但不擦除用户数据区；
* apk: 安装apk目录下的Android应用；
 

