# Jenkins Setup Script for Windows
# Run this script as Administrator

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins Flutter CI/CD Setup for Windows" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Warning: This script should be run as Administrator" -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit
    }
}

# Function to check if a command exists
function Test-Command {
    param($command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

# Check for Java
Write-Host "Checking for Java..." -ForegroundColor Yellow
if (-not (Test-Command "java")) {
    Write-Host "Java is not installed." -ForegroundColor Red
    Write-Host "Please install Java 17 or higher:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://adoptium.net/" -ForegroundColor Cyan
    Write-Host "2. Install Java 17 JDK" -ForegroundColor Cyan
    Write-Host "3. Add JAVA_HOME to environment variables" -ForegroundColor Cyan
    Write-Host ""
    $installJava = Read-Host "Have you installed Java? (Y/N)"
    if ($installJava -ne "Y" -and $installJava -ne "y") {
        Write-Host "Please install Java first and run this script again." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Java is installed:" -ForegroundColor Green
    java -version
    Write-Host ""
}

# Check for Git
Write-Host "Checking for Git..." -ForegroundColor Yellow
if (-not (Test-Command "git")) {
    Write-Host "Git is not installed." -ForegroundColor Red
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "Git is installed:" -ForegroundColor Green
    git --version
    Write-Host ""
}

# Install Jenkins
Write-Host "Installing Jenkins..." -ForegroundColor Yellow

$jenkinsInstalled = Get-Service -Name "Jenkins" -ErrorAction SilentlyContinue

if ($null -eq $jenkinsInstalled) {
    Write-Host "Jenkins service not found. Installing Jenkins..." -ForegroundColor Yellow
    
    # Download Jenkins Windows installer
    $jenkinsUrl = "https://get.jenkins.io/war-stable/latest/jenkins.war"
    $jenkinsPath = "$env:ProgramFiles\Jenkins"
    $jenkinsWar = "$jenkinsPath\jenkins.war"
    
    # Create Jenkins directory
    if (-not (Test-Path $jenkinsPath)) {
        New-Item -ItemType Directory -Path $jenkinsPath -Force | Out-Null
    }
    
    Write-Host "Downloading Jenkins..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $jenkinsUrl -OutFile $jenkinsWar -UseBasicParsing
        Write-Host "Jenkins downloaded successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download Jenkins. Please download manually from:" -ForegroundColor Red
        Write-Host "https://www.jenkins.io/download/" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Or use Chocolatey to install:" -ForegroundColor Yellow
        Write-Host "choco install jenkins" -ForegroundColor Cyan
        exit
    }
    
    Write-Host ""
    Write-Host "Jenkins WAR file downloaded to: $jenkinsWar" -ForegroundColor Green
    Write-Host ""
    Write-Host "To run Jenkins:" -ForegroundColor Yellow
    Write-Host "1. Open Command Prompt or PowerShell as Administrator" -ForegroundColor Cyan
    Write-Host "2. Navigate to: $jenkinsPath" -ForegroundColor Cyan
    Write-Host "3. Run: java -jar jenkins.war" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or install as Windows Service using:" -ForegroundColor Yellow
    Write-Host "choco install jenkins" -ForegroundColor Cyan
    Write-Host ""
    
} else {
    Write-Host "Jenkins service is already installed!" -ForegroundColor Green
    Write-Host "Status: $($jenkinsInstalled.Status)" -ForegroundColor Cyan
    Write-Host ""
}

# Install Flutter
Write-Host "Checking for Flutter..." -ForegroundColor Yellow
$flutterPath = "C:\src\flutter"
$flutterBin = "$flutterPath\bin\flutter.bat"

if (-not (Test-Path $flutterBin)) {
    Write-Host "Flutter is not installed." -ForegroundColor Yellow
    Write-Host "Installing Flutter..." -ForegroundColor Yellow
    
    # Create Flutter directory
    $flutterParent = Split-Path $flutterPath -Parent
    if (-not (Test-Path $flutterParent)) {
        New-Item -ItemType Directory -Path $flutterParent -Force | Out-Null
    }
    
    # Clone Flutter
    Write-Host "Cloning Flutter repository..." -ForegroundColor Yellow
    try {
        Set-Location $flutterParent
        git clone https://github.com/flutter/flutter.git -b stable
        Write-Host "Flutter installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to clone Flutter. Please install manually:" -ForegroundColor Red
        Write-Host "1. Download from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
        Write-Host "2. Extract to C:\src\flutter" -ForegroundColor Cyan
        Write-Host "3. Add C:\src\flutter\bin to PATH" -ForegroundColor Cyan
    }
} else {
    Write-Host "Flutter is already installed at: $flutterPath" -ForegroundColor Green
}

# Add Flutter to PATH
Write-Host ""
Write-Host "Adding Flutter to PATH..." -ForegroundColor Yellow
$flutterBinPath = "$flutterPath\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$flutterBinPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "User")
    Write-Host "Flutter added to PATH!" -ForegroundColor Green
    Write-Host "Please restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host "Flutter is already in PATH." -ForegroundColor Green
}

# Verify Flutter installation
if (Test-Path $flutterBin) {
    Write-Host ""
    Write-Host "Verifying Flutter installation..." -ForegroundColor Yellow
    & $flutterBin doctor
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Start Jenkins:" -ForegroundColor Cyan
Write-Host "   java -jar $jenkinsPath\jenkins.war" -ForegroundColor White
Write-Host ""
Write-Host "2. Access Jenkins at: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Get initial admin password from:" -ForegroundColor Cyan
Write-Host "   C:\Users\$env:USERNAME\.jenkins\secrets\initialAdminPassword" -ForegroundColor White
Write-Host "   OR check console output when starting Jenkins" -ForegroundColor White
Write-Host ""
Write-Host "4. Install recommended plugins" -ForegroundColor Cyan
Write-Host ""
Write-Host "5. Configure Global Tools:" -ForegroundColor Cyan
Write-Host "   - Flutter SDK: $flutterPath" -ForegroundColor White
Write-Host "   - JDK: Configure Java 17" -ForegroundColor White
Write-Host ""
Write-Host "6. Create Pipeline job pointing to your GitHub repo" -ForegroundColor Cyan
Write-Host ""
Write-Host "For detailed instructions, see JENKINS_WINDOWS_SETUP.md" -ForegroundColor Yellow

