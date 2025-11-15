@echo off
REM Jenkins Startup Script for Windows
REM Run this script to start Jenkins manually

echo ==========================================
echo Starting Jenkins Server
echo ==========================================
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install Java 17 or higher
    pause
    exit /b 1
)

REM Set Jenkins home directory
set JENKINS_HOME=%USERPROFILE%\.jenkins

REM Set Jenkins port (change if needed)
set JENKINS_PORT=8080

REM Jenkins WAR file location (check user directory first, then Program Files)
set JENKINS_WAR=%USERPROFILE%\Jenkins\jenkins.war
if not exist "%JENKINS_WAR%" (
    set JENKINS_WAR=C:\Program Files\Jenkins\jenkins.war
)

REM Check if Jenkins WAR exists
if not exist "%JENKINS_WAR%" (
    echo ERROR: Jenkins WAR file not found
    echo Please download Jenkins from https://www.jenkins.io/download/
    echo Or run the setup script: jenkins-setup-windows.ps1
    pause
    exit /b 1
)

echo Jenkins Home: %JENKINS_HOME%
echo Jenkins Port: %JENKINS_PORT%
echo Jenkins WAR: %JENKINS_WAR%
echo.
echo Starting Jenkins...
echo Access Jenkins at: http://localhost:%JENKINS_PORT%
echo.
echo Press Ctrl+C to stop Jenkins
echo.

REM Start Jenkins
java -jar "%JENKINS_WAR%" --httpPort=%JENKINS_PORT%

pause

