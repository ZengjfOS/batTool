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
set "pull_con="
set "flash_uk_con="
set "flash_all_con="
set "flash_all_no_erase_con="
set "apk_con="
set "root_con="
set "copy_con="
set "test_con="

set /P command=%~n0 $:
if "%command%" == ""                            goto :reCMD

echo -^>Your CMD is: %command%
if "%command%" == "0"                           goto :exit
if "%command%" == "exit"                        goto :exit

if "%command%" == "1"                           set "disverity_con=y"
if "%command%" == "disverity"                   set "disverity_con=y"
if "%command%" == "reboot"                      set "disverity_con=y"

if "%command%" == "2"                           set "push_con=y"
if "%command%" == "push"                        set "push_con=y"

if "%command%" == "3"                           set "pull_con=y"
if "%command%" == "pull"                        set "pull_con=y"

if "%command%" == "4"                           set "flash_uk_con=y"
if "%command%" == "flash uk"                    set "flash_uk_con=y"

if "%command%" == "5"                           set "flash_all_con=y"
if "%command%" == "flash all"                   set "flash_all_con=y"

if "%command%" == "6"                           set "flash_all_no_erase_con=y"
if "%command%" == "flash all diserase"          set "flash_all_no_erase_con=y"

if "%command%" == "7"                           set "apk_con=y"
if "%command%" == "apk"                         set "apk_con=y"

if "%command%" == "8"                           set "root_con=y"
if "%command%" == "root"                        set "root_con=y"

if "%command%" == "9"                           set "copy_con=y"
if "%command%" == "copy"                        set "copy_con=y"

if "%command%" == "test"                        set "test_con=y"

if defined disverity_con (
    set "workDir=%curDir%"
) else if defined push_con (
    set "workDir=%curDir%\fs"
) else if defined pull_con (
    set "workDir=%curDir%\pull"
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
) else if defined copy_con (
    set "workDir=%curDir%\copy"
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
) else if defined pull_con (
    call:pull
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
) else if defined copy_con (
    call:copy
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
        if not ".disable" == "%%~xf" (
            adb shell mkdir -p !LinuxRelPathDir!
            adb push !winRelPath! !LinuxRelPath!
        ) else (
            echo Note: skip push !winRelPath!
        )
    )
)
goto:eof

:: pull file from Android file system
:pull

echo %cd%

if exist "config.txt" (
    echo ----^>start copy flash image
    for /F %%k in (config.txt) do ( 
        adb pull %%k .
    )
    echo ^<----end copy flash image
) else (
    echo Please check your "pull/config.txt" exist.
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
        if not ".disable" == "%%~xf" (
            adb install -t !relPath!
        ) else (
            echo Note: skip !relPath!
        )
    )
)
goto:eof


:: install apk to Android
:root
adb root
adb remount
adb shell setenforce 0
adb shell getenforce

if exist "root\temp.bat" (
    echo ----^>enter temp.bat
    call root\temp.bat
    echo ^<----exit temp.bat
)
goto:eof


:: exit bat file
:exit
cd %curDir%
echo ^<- Exit program
echo.
pause
::@echo on
goto:eof


:: copy image
:copy
if exist "config.txt" (
    for /F "tokens=1,2 delims==" %%k in (%curDir%/copy/config.txt) do ( 
        if "baseDir" == "%%k" (
            set "baseDir=%%l"
            echo %baseDir%

            cd "%workDir%\flash"
            echo ----^>start copy flash image
            call:copy_file flash 
            echo ^<----end copy flash image

            cd "%workDir%\fs"
            echo ----^>start copy fs
            call:copy_file fs
            echo ^<----end copy fs
        ) 
    )
) else (
    echo Please check your "copy/config.txt" exist.
)
goto:eof

:: copy file system
:copy_file
for /R "%cd%" %%f in (*.*) do ( 
    if not "%%~nf" == "placefile" (
        set "file=%%f"
        set relPath=!file:%workDir%\%1\=!
        echo Relative Path: !relPath!
        set imgPath=%baseDir%\!relPath!
        if not ".disable" == "%%~xf" (
            if exist "!imgPath!" (
                set winimgPath=%curDir%\%1\!relPath!
                echo img Path: !imgPath!
                echo win img Path: !winimgPath!
                xcopy !imgPath! !winimgPath!* /e /i /y
                echo xcopy !imgPath! !winimgPath! /e /i /y
            ) else (
                echo Warning ** image file not exist **
            )
        ) else (
            echo Note: skip  copy !imgPath!
        )
    )
)
goto:eof


:: help info
:help
:: Custom your help info
echo =========================================================
echo %1 Help Info:
echo     0. 'exit': exit the bat program
echo     1. 'disverity': disable verity Android P and auto reboot
echo     2. 'push': push file to Android P
echo     3. 'pull': pull file from Android P
echo     4. 'flash uk': flash uboot/kernel to board
echo     5. 'flash all': flash all file to board
echo     6. 'flash all diserase': flash all file to board with no erase data partition
echo     7. 'apk': install apk to board
echo     8. 'root': set Android P adb with root/remount/setenforce 0
echo     9. 'copy': copy Android build out file to flash/fs folder
echo =========================================================
echo.
goto:eof


:: test command for write this bat file
:test
echo test function
goto:eof
