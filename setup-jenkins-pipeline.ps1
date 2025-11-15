# Jenkins Pipeline Setup Script
# This script helps configure Jenkins to run the CI/CD pipeline

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins CI/CD Pipeline Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Jenkins is running
Write-Host "Checking if Jenkins is running..." -ForegroundColor Yellow
$jenkinsRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
    $jenkinsRunning = $true
    Write-Host "Jenkins is running on http://localhost:8080" -ForegroundColor Green
} catch {
    Write-Host "Jenkins is not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Jenkins first:" -ForegroundColor Yellow
    Write-Host "1. Install Java 17 if not installed" -ForegroundColor Cyan
    Write-Host "2. Run: .\start-jenkins.bat" -ForegroundColor Cyan
    Write-Host "   OR: .\setup-and-start-jenkins.ps1" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Pipeline Configuration Guide" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Follow these steps to set up your CI/CD pipeline:" -ForegroundColor Yellow
Write-Host ""

Write-Host "STEP 1: Access Jenkins" -ForegroundColor Cyan
Write-Host "  Open: http://localhost:8080" -ForegroundColor White
Write-Host ""

Write-Host "STEP 2: Install Required Plugins" -ForegroundColor Cyan
Write-Host "  1. Go to: Manage Jenkins -> Manage Plugins -> Available" -ForegroundColor White
Write-Host "  2. Install these plugins:" -ForegroundColor White
Write-Host "     - Git Plugin" -ForegroundColor Gray
Write-Host "     - Pipeline Plugin" -ForegroundColor Gray
Write-Host "     - Flutter Plugin (if available)" -ForegroundColor Gray
Write-Host "     - HTML Publisher Plugin" -ForegroundColor Gray
Write-Host "     - Test Results Analyzer Plugin" -ForegroundColor Gray
Write-Host "     - Coverage Plugin" -ForegroundColor Gray
Write-Host "  3. Restart Jenkins if prompted" -ForegroundColor White
Write-Host ""

Write-Host "STEP 3: Configure Global Tools" -ForegroundColor Cyan
Write-Host "  1. Go to: Manage Jenkins -> Global Tool Configuration" -ForegroundColor White
Write-Host "  2. Configure JDK:" -ForegroundColor White
Write-Host "     - Name: JDK-17" -ForegroundColor Gray
Write-Host "     - JAVA_HOME: (path to your Java 17 installation)" -ForegroundColor Gray
Write-Host "  3. Configure Flutter (if plugin installed):" -ForegroundColor White
Write-Host "     - Name: Flutter-Stable" -ForegroundColor Gray
Write-Host "     - Installation directory: (path to Flutter SDK)" -ForegroundColor Gray
Write-Host "  4. OR add Flutter to PATH:" -ForegroundColor White
Write-Host "     - Go to: Manage Jenkins -> Configure System" -ForegroundColor Gray
Write-Host "     - Global properties -> Environment variables" -ForegroundColor Gray
Write-Host "     - Add: PATH = C:\src\flutter\bin;%PATH%" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 4: Create Pipeline Job" -ForegroundColor Cyan
Write-Host "  1. Click New Item" -ForegroundColor White
Write-Host "  2. Enter name: Flutter-CI-CD" -ForegroundColor White
Write-Host "  3. Select Pipeline and click OK" -ForegroundColor White
Write-Host "  4. In Pipeline section:" -ForegroundColor White
Write-Host "     - Definition: Pipeline script from SCM" -ForegroundColor Gray
Write-Host "     - SCM: Git" -ForegroundColor Gray
Write-Host "     - Repository URL: (your repository URL)" -ForegroundColor Gray
Write-Host "     - Credentials: (add if private repo)" -ForegroundColor Gray
Write-Host "     - Branches to build: */main or */master" -ForegroundColor Gray
Write-Host "     - Script Path: Jenkinsfile" -ForegroundColor Gray
Write-Host "       (or Jenkinsfile.windows for Windows-specific version)" -ForegroundColor Gray
Write-Host "  5. Click Save" -ForegroundColor White
Write-Host ""

Write-Host "STEP 5: Run Your First Build" -ForegroundColor Cyan
Write-Host "  1. Click Build Now on your pipeline job" -ForegroundColor White
Write-Host "  2. Watch the build progress" -ForegroundColor White
Write-Host "  3. Check console output for details" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Quick Start Commands" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To test the pipeline locally (without Jenkins):" -ForegroundColor Yellow
Write-Host "  flutter pub get" -ForegroundColor Cyan
Write-Host "  flutter analyze" -ForegroundColor Cyan
Write-Host "  flutter test" -ForegroundColor Cyan
Write-Host "  flutter build apk --release" -ForegroundColor Cyan
Write-Host ""

Write-Host "Jenkinsfile locations:" -ForegroundColor Yellow
Write-Host "  - Jenkinsfile (Unix/Linux compatible)" -ForegroundColor Cyan
Write-Host "  - Jenkinsfile.windows (Windows compatible)" -ForegroundColor Cyan
Write-Host ""

Write-Host "For more details, see:" -ForegroundColor Yellow
Write-Host "  - JENKINS_WINDOWS_SETUP.md" -ForegroundColor Cyan
Write-Host "  - QUICK_START.md" -ForegroundColor Cyan
Write-Host ""
