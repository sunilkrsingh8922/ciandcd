@echo off
REM Jenkins Stop Script for Windows
REM Stops Jenkins Windows Service

echo ==========================================
echo Stopping Jenkins Service
echo ==========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script must be run as Administrator
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Stop Jenkins service
echo Stopping Jenkins service...
sc stop Jenkins

if %errorlevel% equ 0 (
    echo Jenkins service stopped successfully
) else (
    echo Failed to stop Jenkins service
    echo Jenkins may not be running as a service
    echo If running manually, press Ctrl+C in the Jenkins console
)

pause

