@echo off
setlocal enabledelayedexpansion enableextensions

set curDir=%cd%
echo current dir:%curDir%

set ADBConnected=0
set ADBStatus=unconnected
call:connected

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
set "apk_con="
set "root_con="
set "copy_con="
set "open_con="
set "log_con="
set "test_con="
set "unlock_con="
set "checkADB="
set "ADBConnected=0"

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

if "%command%" == "4"                           set "apk_con=y"
if "%command%" == "apk"                         set "apk_con=y"

if "%command%" == "5"                           set "root_con=y"
if "%command%" == "root"                        set "root_con=y"

if "%command%" == "6"                           set "copy_con=y"
if "%command%" == "copy"                        set "copy_con=y"

if "%command%" == "7"                           set "unlock_con=y"
if "%command%" == "unlock"                      set "unlock_con=y"

if "%command%" == "8"                           set "open_con=y"
if "%command%" == "open"                        set "open_con=y"

if "%command%" == "9"                           set "log_con=y"
if "%command%" == "log"                         set "log_con=y"

if "%command%" == "test"                        set "test_con=y"

if defined disverity_con (
    set "checkADB=y"
    set "workDir=%curDir%"
) else if defined push_con (
    set "checkADB=y"
    set "workDir=%curDir%\fs"
) else if defined pull_con (
    set "checkADB=y"
    set "workDir=%curDir%\pull"
) else if defined apk_con (
    set "checkADB=y"
    set "workDir=%curDir%\apk"
) else if defined root_con (
    set "checkADB=y"
    set "workDir=%curDir%"
) else if defined copy_con (
    set "checkADB=n"
    set "workDir=%curDir%\copy"
) else if defined open_con (
    set "checkADB=n"
    set "workDir=%curDir%\open"
) else if defined log_con (
    set "checkADB=y"
    set "workDir=%curDir%\log"
) else if defined test_con (
    set "checkADB=n"
    set "workDir=%curDir%\test"
) else if defined unlock_con (
    rem set "checkADB=y"
) else (
    echo **Warning: Do't support this command currently**
    echo.
    goto :reCMD
)

echo %command%'s work dir:%workDir%
echo --^> Enter execute %command%
cd %workDir%

call:connected
if "y" == "%checkADB%" (
    if %ADBConnected% == 0 ( echo info: plz check ADB connected & goto :reCMD )
) else (
    echo info: skip adb check & goto unCheckADB
)

echo status: ADB: !ADBStatus!
set /P checkContinue=execute CMD? (y/n): 
If NOT %checkContinue% == y (
    goto :reCMD
) 

:unCheckADB

if defined disverity_con (
    call:disverity
) else if defined push_con (
    call:push
) else if defined pull_con (
    call:pull
) else if defined apk_con (
    call:apk
) else if defined root_con (
    call:root
) else if defined copy_con (
    if %ADBConnected% == 1 ( call:root )
    call:copy
) else if defined unlock_con (
    call:unlock
) else if defined open_con (
    call:open
) else if defined log_con (
    call:log
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
echo start adb root
adb root
echo end adb root
echo start adb disable-verity
adb disable-verity
echo end adb disable-verity
echo start adb reboot
adb shell reboot
goto:eof


:: push file to Android file system
:push
adb root
adb remount > nul
if %errorlevel% == 0 (
    echo remount success

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
) else (
    echo remount failed
)
goto:eof

:: pull file from Android file system
:pull

if exist "config.txt" (
    echo ----^>start pull file from android
    for /F %%k in (config.txt) do ( 
        if not ".disable" == "%%~xk" (
            adb pull %%k .
        ) else (
            echo Note: **skip**  pull %%k
        )
    )
    echo ^<----end pull file from android
) else (
    echo Please check your "pull/config.txt" exist.
)
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


:: root Android
:root
adb root
adb remount > nul
if %errorlevel% == 0 (
    echo remount success

    if exist "root\temp.bat" (
        echo ----^>enter temp.bat
        call root\temp.bat
        echo ^<----exit temp.bat
    )
) else (
    echo remount failed
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


:: copy image and fs
:copy
if exist "config.txt" (
    for /F "tokens=1,2 delims==" %%k in (config.txt) do ( 
        echo %%k = %%l
        if "sambaBaseDir" == "%%k" (
            set "sambaBaseDir=%%l"
            echo !sambaBaseDir!
        ) else if "flashTargetDir" == "%%k" (
            set "flashTargetDir=%%l"
            echo !flashTargetDir!
        ) else if "fsTargetDir" == "%%k" (
            set "fsTargetDir=%%l"
            echo !fsTargetDir!
        )
    )

    if "!sambaBaseDir!" == "" (
        echo sambaBaseDir is empty
        goto:eof
    )

    if "!flashTargetDir!" == "" (
        echo flashTargetDir is empty
        goto:eof
    )

    if "!fsTargetDir!" == "" (
        echo fsTargetDir is empty
        goto:eof
    )

    cd "%workDir%\flash"
    echo ----^>start copy flash image
    call:copy_file flash !flashTargetDir!
    echo ^<----end copy flash image


    cd "%workDir%\fs"
    echo ----^>start copy fs
    call:copy_file fs !fsTargetDir!
    echo ^<----end copy fs
) else (
    echo Please check your "copy/config.txt" exist.
)
goto:eof


:: copy file system
:copy_file
if exist "config.txt" (
    for /F %%l in (config.txt) do ( 
        set relPath=%%l
        echo Relative Path: !relPath!
        set imgPath=%sambaBaseDir%\!relPath:/=\!
        if not ".disable" == "%%~xl" (
            if exist "!imgPath!" (
                if "%1" == "fs" (
                    set winimgPath=%curDir%\%1\!relPath:/=\!
                ) else (
                    set winimgPath=%2\!relPath:/=\!
                )
                echo img Path: !imgPath!
                echo win img Path: !winimgPath!
                echo xcopy !imgPath! !winimgPath! /i /y
                echo F | xcopy !imgPath! !winimgPath! /i /y

                if "%1" == "fs" (
                    if %ADBConnected% == 1 ( 
                        echo auto push file: !winimgPath!
                        adb push !imgPath! !relPath!
                    ) else (
                        echo Note: **skip** push file: !winimgPath!
                    )
                )

            ) else (
                echo Warning ** image file not exist **
            )
        ) else (
            echo Note: **skip**  copy !imgPath!
        )
    )

    if %ADBConnected% == 1 ( 
        adb shell sync
    )
) else (
    echo Please check your "copy/%1/config.txt" exist.
)
goto:eof


:: help info
:help
:: Custom your help info
echo =========================================================
echo %1 Help Info:
echo     0. 'exit': exit the bat program
echo     1. 'disverity': disable verity Android and auto reboot
echo     2. 'push': push file to Android
echo     3. 'pull': pull file from Android
echo     4. 'apk': install apk to Android
echo     5. 'root': set Android P adb with root/remount
echo     6. 'copy': copy Android build out file to flash/fs folder
echo     7. 'unlock': unlock the disable verity in u-boot
echo     8. 'open': auto exploer open dir
echo     9. 'log': auto pull /sdcard/debuglogger to log dir
echo =========================================================
echo status: ADB: !ADBStatus!
echo.
goto:eof


:connected
set count=0
for /F "tokens=*" %%i in ('adb devices') do ( set /a count=!count!+1 )
if /i !count! geq 2 ( set ADBConnected=1 ) else ( set ADBConnected=0 )
if %ADBConnected% == 1 (
    set "ADBStatus=connected"
) else (
    set "ADBStatus=unconnected"
)
echo **note: ADB %ADBStatus%**
goto:eof


:unlock
echo unlock
adb reboot bootloader
echo device is rebooting to u-boot
echo waiting 10 second max to unlock device
::timeout 20 
fastboot flashing unlock
echo please reboot by long press the power button!!
timeout 30
call:ADB_CONNECTED
call:disverity
timeout 10
call:ADB_CONNECTED
adb root
adb remount
goto:eof


:ADB_CONNECTED
@adb devices | findstr "\<device\>"
IF ERRORLEVEL 1 goto ADB_CONNECTED
echo adb connete
goto:eof



:: open dir
:open
for /F "tokens=1,2 delims==" %%k in (config.txt) do ( 
    if "open" == "%%k" (
        set relPath=%%l
        echo opening dir: !relPath!
        if not ".disable" == "%%~xl" (
            if exist "!relPath!" (
                rem start "" %%l
                start "" !relPath!
                timeout 1 > NUL

            ) else (
                echo Warning ** open dir not exist **
            )
        ) else (
            echo Note: **skip**  open !relPath!
        )
    ) else (
        set relPath=%%l
        echo execute: %%k !relPath!
        if not ".disable" == "%%~xl" (
            if exist "!relPath!" (
                rem start %%k !relPath!
                rem timeout 1 > NUL
            ) else (
                echo Warning ** execute dir not exist **
            )
        ) else (
            echo Note: **skip**  execute %%k !relPath!
        )
    )
)
goto:eof

:: log dir
:log
adb shell sync
adb pull /sdcard/debuglogger .
goto:eof


:: test command for write this bat file
:test
echo test function
goto:eof