@echo off
setlocal enabledelayedexpansion

:: Check for Administrator privileges
openfiles >nul 2>&1
if errorlevel 1 (
    echo ERROR: Please run this script as ADMINISTRATOR. 
    exit /b 1
)

echo Scanning for installed JDKs in C:\Program Files\Java...
echo.

set "SCRIPT_DIR=%~dp0"
set "JAVA_BASE=C:\Program Files\Java"

:: Create missing wrapper scripts
echo Checking for new JDKs...
set "CREATED_COUNT=0"
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
        echo   [+] Created java!MAJOR_VER!.bat
        set /a CREATED_COUNT+=1
        echo @echo off > "!BAT_FILE!"
        echo call "%%~dp0javax.bat" java!MAJOR_VER! >> "!BAT_FILE!"
    )
)
if !CREATED_COUNT! equ 0 echo   (No new scripts created)
echo.

:: Delete orphaned wrapper scripts
echo Cleaning up orphaned scripts...
set "DELETED_COUNT=0"
for %%f in ("!SCRIPT_DIR!java*.bat") do (
    set "FILENAME=%%~nxf"
    if /i not "!FILENAME!"=="javax.bat" if /i not "!FILENAME!"=="javalist.bat" if /i not "!FILENAME!"=="javasync.bat" if /i not "!FILENAME!"=="javahelp.bat" (
        set "VERSION_NUM=!FILENAME:java=!"
        set "VERSION_NUM=!VERSION_NUM:.bat=!"
        
        set "MATCH_FOUND=0"
        
        :: Check if corresponding JDK exists using the same logic as javax.bat
        if !VERSION_NUM! leq 8 (
            set "SEARCH_PATTERN=jdk-1.!VERSION_NUM!"
        ) else (
            set "SEARCH_PATTERN=jdk-!VERSION_NUM!"
        )
        
        :: Check if any JDK folder matches the pattern
        for /d %%d in ("%JAVA_BASE%\!SEARCH_PATTERN!*") do (
            set "MATCH_FOUND=1"
        )
        
        if "!MATCH_FOUND!"=="0" (
            echo   [-] Deleted !FILENAME! - JDK missing - searched for !SEARCH_PATTERN!
            set /a DELETED_COUNT+=1
            del "%%f"
        )
    )
)
if !DELETED_COUNT! equ 0 echo   (No orphaned scripts found)

echo.
echo Sync complete - !CREATED_COUNT! created, !DELETED_COUNT! deleted.
echo Use 'javalist' to see all versions or type 'javaXX' to switch.
