@echo off
setlocal enabledelayedexpansion enableextensions

set curDir=%cd%
echo current dir:%curDir%

set "xenFlag=0"
set "xenStatus=standard"
::set "xenFlag=1"
::set "xenStatus=xen"
echo note: %xenStatus% mode(standard or xen mode)

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
set "flash_uk_con="
set "flash_all_con="
set "test_con="
set "xen_con="

set /P command=%~n0 $:
if "%command%" == ""                            goto :reCMD

echo -^>Your CMD is: %command%
if "%command%" == "0"                           goto :exit
if "%command%" == "exit"                        goto :exit

if "%command%" == "1"                           set "flash_uk_con=y"
if "%command%" == "flash uk"                    set "flash_uk_con=y"

if "%command%" == "2"                           set "flash_all_con=y"
if "%command%" == "flash all"                   set "flash_all_con=y"

if "%command%" == "3"                          set "xen_con=y"
if "%command%" == "xen"                         set "xen_con=y"

if "%command%" == "test"                        set "test_con=y"

if defined flash_uk_con (
    set "workDir=%curDir%\flash"
) else if defined flash_all_con (
    set "workDir=%curDir%\flash"
) else if defined xen_con (
    echo before is !xenStatus!^(xenFlag: !xenFlag!^) mode
    if %xenFlag% == 0 (
        set "xenFlag=1"
        set "xenStatus=xen"
    ) else (
        set "xenFlag=0"
        set "xenStatus=standard"
    )
    echo change to !xenStatus!^(xenFlag: !xenFlag!^) mode
    echo current is !xenStatus!^(xenFlag: !xenFlag!^) mode
    goto :reCMD
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

echo status: fw type: !xenStatus!
set /P checkContinue=execute CMD? (y/n): 
If NOT %checkContinue% == y (
    goto :reCMD
) 

if defined flash_uk_con (
    xcopy ..\tools\flash.bin flash.bin /i /y
    call:flash_uk
) else if defined flash_all_con (
    xcopy ..\tools\flash.bin flash.bin /i /y
    call:flash_all
) else if defined test_con (
    call:test
)

cd %curDir%
echo ^<-- Exit execute %command%

pause
test&cls

goto :whileLoop

:: flash uboot/kernel img to eMMC
:flash_uk
if %xenFlag% == 0 (
    uuu.exe uuu-Linux-mx8qm-mek-sd-part.lst
) else (
    uuu.exe uuu-Linux-mx8qm-mek-sd-part-xen.lst
)
goto:eof


:: flash all img to eMMC
:flash_all
if %xenFlag% == 0 (
    uuu.exe uuu-Linux-mx8qm-mek-sd.lst
) else (
    uuu.exe uuu-Linux-mx8qm-mek-sd-xen.lst
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


:: help info
:help
:: Custom your help info
echo =========================================================
echo %1 Help Info:
echo     0. 'exit': exit the bat program
echo     1. 'flash uk': flash uboot/kernel to board
echo     2. 'flash all': flash all file to board
echo     3. 'xen': standard(default) or xen mode
echo =========================================================
echo status: fw type: !xenStatus!
echo.
goto:eof

:: test command for write this bat file
:test
echo test function
goto:eof

