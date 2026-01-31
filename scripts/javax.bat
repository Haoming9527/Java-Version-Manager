@echo off
:: Get input arguments
set "VERSION=%1"

:: Extract version number (strip "java" prefix)
setlocal enabledelayedexpansion
set "verNum=%VERSION:~4%"


:: Search for JDK directory
if %verNum% leq 8 (
    set "SEARCH_PATTERN=jdk-1.%verNum%*"
) else (
    set "SEARCH_PATTERN=jdk-%verNum%*"
)

set "FOUND_JAVA_HOME="
for /d %%i in ("C:\Program Files\Java\%SEARCH_PATTERN%") do (
    set "FOUND_JAVA_HOME=%%i"
)

if not defined FOUND_JAVA_HOME (
    echo ERROR: No JDK folder found matching %SEARCH_PATTERN% in C:\Program Files\Java
    exit /b 1
)

endlocal & set "JAVA_HOME=%FOUND_JAVA_HOME%"

:: Verify JAVA_HOME exists
if not exist "%JAVA_HOME%\bin\java.exe" (
  echo JAVA_HOME path not found: %JAVA_HOME%
  exit /b 1
)

:: Set permanent JAVA_HOME
setx JAVA_HOME "%JAVA_HOME%" /M
if errorlevel 1 (
  echo ERROR: Failed to set system environment variable. Make sure you're running as administrator.
  exit /b 1
)
echo JAVA_HOME permanently set to %JAVA_HOME%

:: Update PATH for current session
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo %VERSION% activated.
java -version
