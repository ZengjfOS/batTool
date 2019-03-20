@echo off
setlocal enabledelayedexpansion enableextensions

set curDir=%cd%
echo current dir:%curDir%

:whileLoop

if not exist "help.txt" (
    call:help %~n0
) else (
    for /F %%l in (%curDir%\help.txt) do ( 
        echo %%l
    )
)

:: if command is empty, input it again
:reCMD
set "command="
set "disverity_con="
set "push_con="
set "flash_uk_con="
set "flash_all_con="
set "flash_all_no_erase_con="
set "apk_con="
set "root_con="
set "test_con="

set /P command=%~n0 $:
if "%command%" == ""                            goto :reCMD

echo -^>Your CMD is: %command%
if "%command%" == "8"                        goto :exit
if "%command%" == "exit"                        goto :exit

if "%command%" == "1"                           set "disverity_con=y"
if "%command%" == "disverity"                   set "disverity_con=y"

if "%command%" == "2"                           set "push_con=y"
if "%command%" == "push"                        set "push_con=y"

if "%command%" == "3"                           set "flash_uk_con=y"
if "%command%" == "flash uk"                    set "flash_uk_con=y"

if "%command%" == "4"                           set "flash_all_con=y"
if "%command%" == "flash all"                   set "flash_all_con=y"

if "%command%" == "5"                           set "flash_all_no_erase_con=y"
if "%command%" == "flash all no erase"          set "flash_all_no_erase_con=y"

if "%command%" == "6"                           set "apk_con=y"
if "%command%" == "apk"                         set "apk_con=y"

if "%command%" == "7"                           set "root_con=y"
if "%command%" == "root"                        set "root_con=y"

if "%command%" == "test"                        set "test_con=y"

if defined disverity_con (
    set "workDir=%curDir%"
) else if defined push_con (
    set "workDir=%curDir%\fs"
) else if defined flash_uk_con (
    set "workDir=%curDir%\flash"
) else if defined flash_all_con (
    set "workDir=%curDir%\flash"
) else if defined flash_all_no_erase_con (
    set "workDir=%curDir%\flash"
) else if defined apk_con (
    set "workDir=%curDir%\apk"
) else if defined root_con (
    set "workDir=%curDir%"
) else if defined test_con (
    set "workDir=%curDir%\test"
) else (
    echo **Warning: Do't support this command currently**
    echo.
    goto :reCMD
)

echo %command%'s work dir:%workDir%
echo --^> Enter execute %command%
cd %workDir%

if defined disverity_con (
    call:disverity
) else if defined push_con (
    call:push
) else if defined flash_uk_con (
    call:flash_uk
) else if defined flash_all_con (
    call:flash_all
) else if defined flash_all_no_erase_con (
    call:flash_all_on_erase
) else if defined apk_con (
    call:apk
) else if defined root_con (
    call:root
) else if defined test_con (
    call:test
)

cd %curDir%
echo ^<-- Exit execute %command%

pause
test&cls

goto :whileLoop


:: disable verity
:disverity 
adb root
adb disable-verity
adb shell reboot
goto:eof


:: push file to Android file system
:push
adb root
adb remount

for /R %cd% %%f in (*.*) do ( 
    set "file=%%f"
    set "fileDir=%%~pf"
    set winRelPath=!file:%workDir%\=!
    set winRelPathDir=!fileDir:%workDir:~2%\=!
    echo Windows Relative Path: !winRelPath!
    echo Windows Relative Path Dir: !winRelPathDir!

    set "LinuxRelPath=/!winRelPath:\=/!"
    echo Linux Relative Path: !LinuxRelPath!
    if not "!winRelPathDir!" == "" (
        set "LinuxRelPathDir=/!winRelPathDir:\=/!"
        set "LinuxRelPathDir=!LinuxRelPathDir:~0,-1!"
    ) else (
        set "LinuxRelPathDir=/"
    )
    echo Linux Relative Path Dir: !LinuxRelPathDir!

    if "!winRelPath!" == "placefile" (
        echo Note: Nothing
    ) else (
        adb shell mkdir -p !LinuxRelPathDir!
        adb push !winRelPath! !LinuxRelPath!
    )
)
goto:eof


:: flash uboot/kernel img to eMMC
:flash_uk
uuu.exe uuu-android-mx8qm-mek-emmc-part.lst
goto:eof


:: flash all img to eMMC
:flash_all
uuu.exe uuu-android-mx8qm-mek-emmc.lst
goto:eof

:: flash all img to eMMC with no erase data partition
:flash_all_on_erase
uuu.exe uuu-android-mx8qm-mek-emmc-no-erase.lst
goto:eof


:: install apk to Android
:apk
for /R %cd% %%f in (*.*) do ( 
    if not "%%~nf" == "placefile" (
        echo Absolute Path: %%f
        echo file name: %%~nf
        set "file=%%f"
        set relPath=!file:%workDir%\=!
        echo Relative Path: !relPath!
        adb install -t !relPath!
    )
)
goto:eof


:: install apk to Android
:root
adb root
adb remount
adb shell setenforce 0
adb shell getenforce
goto:eof


:: exit bat file
:exit
cd %curDir%
echo ^<- Exit program
echo.
pause
::@echo on
goto:eof


:: help info
:help
:: Custom your help info
echo =========================================================
echo %1 Help Info:
echo     1. 'disverity' to disable verity Android P and auto reboot
echo     2. 'push' to push file to Android P
echo     3. 'flash uk' to flash uboot/kernel to board
echo     4. 'flash all' to flash all file to board
echo     5. 'flash all no erase' to flash all file to board with no erase data partition
echo     6. 'apk' to install apk to board
echo     7. 'root' to set Android P adb with root/remount/setenforce 0
echo     8. 'exit' to exit the bat program
echo =========================================================
echo.
goto:eof


:: test command for write this bat file
:test
echo test function
goto:eof
