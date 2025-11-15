# Quick Jenkins Setup and Start Script
# This script checks prerequisites and starts Jenkins

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins Local Server Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check Java
Write-Host "Checking Java installation..." -ForegroundColor Yellow
$javaInstalled = $false
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Java is installed:" -ForegroundColor Green
        Write-Host "  $javaVersion" -ForegroundColor Gray
        $javaInstalled = $true
    }
} catch {
    $javaInstalled = $false
}

if (-not $javaInstalled) {
    Write-Host "✗ Java is NOT installed or not in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Java 17 or higher:" -ForegroundColor Yellow
    Write-Host "1. Visit: https://adoptium.net/temurin/releases/" -ForegroundColor Cyan
    Write-Host "2. Download Eclipse Temurin 17 (LTS) for Windows x64" -ForegroundColor Cyan
    Write-Host "3. Run the installer and check 'Add to PATH'" -ForegroundColor Cyan
    Write-Host "4. Restart your terminal and run this script again" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or use winget (Windows 10/11):" -ForegroundColor Yellow
    Write-Host "  winget install EclipseAdoptium.Temurin.17.JDK" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# Check Jenkins WAR file
Write-Host ""
Write-Host "Checking Jenkins installation..." -ForegroundColor Yellow
$jenkinsWar = "$env:USERPROFILE\Jenkins\jenkins.war"
if (-not (Test-Path $jenkinsWar)) {
    $jenkinsWar = "C:\Program Files\Jenkins\jenkins.war"
}

if (-not (Test-Path $jenkinsWar)) {
    Write-Host "✗ Jenkins WAR file not found" -ForegroundColor Red
    Write-Host "  Expected locations:" -ForegroundColor Yellow
    Write-Host "    $env:USERPROFILE\Jenkins\jenkins.war" -ForegroundColor Gray
    Write-Host "    C:\Program Files\Jenkins\jenkins.war" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Downloading Jenkins..." -ForegroundColor Yellow
    $jenkinsDir = "$env:USERPROFILE\Jenkins"
    New-Item -ItemType Directory -Path $jenkinsDir -Force | Out-Null
    $jenkinsUrl = "https://get.jenkins.io/war-stable/2.440.1/jenkins.war"
    try {
        Invoke-WebRequest -Uri $jenkinsUrl -OutFile "$jenkinsDir\jenkins.war" -UseBasicParsing
        $jenkinsWar = "$jenkinsDir\jenkins.war"
        Write-Host "✓ Jenkins downloaded successfully!" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to download Jenkins" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please download manually from: https://www.jenkins.io/download/" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✓ Jenkins WAR file found:" -ForegroundColor Green
    Write-Host "  $jenkinsWar" -ForegroundColor Gray
}

# Check if port 8080 is available
Write-Host ""
Write-Host "Checking port 8080..." -ForegroundColor Yellow
$portInUse = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "⚠ Port 8080 is already in use" -ForegroundColor Yellow
    Write-Host "  You can:" -ForegroundColor Yellow
    Write-Host "  1. Stop the service using port 8080" -ForegroundColor Cyan
    Write-Host "  2. Use a different port: java -jar jenkins.war --httpPort=8081" -ForegroundColor Cyan
    Write-Host ""
    $continue = Read-Host "Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit 0
    }
} else {
    Write-Host "✓ Port 8080 is available" -ForegroundColor Green
}

# Start Jenkins
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Starting Jenkins Server" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Jenkins will start on: http://localhost:8080" -ForegroundColor Green
Write-Host ""
Write-Host "First time setup:" -ForegroundColor Yellow
Write-Host "1. Open http://localhost:8080 in your browser" -ForegroundColor Cyan
Write-Host "2. Get the initial admin password from the console output below" -ForegroundColor Cyan
Write-Host "   OR from: $env:USERPROFILE\.jenkins\secrets\initialAdminPassword" -ForegroundColor Cyan
Write-Host "3. Follow the setup wizard" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop Jenkins" -ForegroundColor Yellow
Write-Host ""

# Set Jenkins home
$env:JENKINS_HOME = "$env:USERPROFILE\.jenkins"

# Start Jenkins
java -jar "$jenkinsWar" --httpPort=8080

