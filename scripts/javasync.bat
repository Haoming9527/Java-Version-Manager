@echo off
setlocal enabledelayedexpansion

echo Scanning for installed JDKs in C:\Program Files\Java...
echo.

set "SCRIPT_DIR=%~dp0"
set "JAVA_BASE=C:\Program Files\Java"

:: Create missing wrapper scripts
for /d %%d in ("%JAVA_BASE%\jdk-*") do (
    set "FOLDER_NAME=%%~nxd"
    
    :: Extract major version
    set "VER_STR=!FOLDER_NAME:jdk-=!"
    
    :: Check if it's 1.x (older Java)
    if "!VER_STR:~0,2!"=="1." (
        set "VER_STR=!VER_STR:~2!"
        for /f "delims=." %%a in ("!VER_STR!") do set "MAJOR_VER=%%a"
    ) else (
        for /f "delims=." %%a in ("!VER_STR!") do set "MAJOR_VER=%%a"
    )

    set "BAT_FILE=!SCRIPT_DIR!java!MAJOR_VER!.bat"
    
    if not exist "!BAT_FILE!" (
        echo [+] Creating java!MAJOR_VER!.bat
        (
            echo @echo off
            echo call "%%~dp0javax.bat" java!MAJOR_VER!
        ) > "!BAT_FILE!"
    )
)

:: Delete orphaned wrapper scripts
for %%f in ("!SCRIPT_DIR!java*.bat") do (
    set "FILENAME=%%~nxf"
    if /i not "!FILENAME!"=="javax.bat" if /i not "!FILENAME!"=="javalist.bat" if /i not "!FILENAME!"=="javasync.bat" if /i not "!FILENAME!"=="javahelp.bat" (
        set "VERSION_NUM=!FILENAME:java=!"
        set "VERSION_NUM=!VERSION_NUM:.bat=!"
        
        set "MATCH_FOUND=0"
        if !VERSION_NUM! leq 8 (
            if exist "%JAVA_BASE%\jdk-1.!VERSION_NUM!*" set "MATCH_FOUND=1"
        ) else (
            if exist "%JAVA_BASE%\jdk-!VERSION_NUM!*" set "MATCH_FOUND=1"
        )
        
        if "!MATCH_FOUND!"=="0" (
            echo [-] Deleting !FILENAME! (JDK missing)
            del "%%f"
        )
    )
)

echo.
echo Sync complete! Use 'javalist' to see all versions or type 'javaXX' to switch.
