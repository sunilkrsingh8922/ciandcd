# Jenkins CI/CD Configuration Script
# This script helps configure Jenkins for your Flutter CI/CD pipeline

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins CI/CD Configuration" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check Jenkins status
Write-Host "Checking Jenkins status..." -ForegroundColor Yellow
$jenkinsRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    $jenkinsRunning = $true
    Write-Host "Jenkins is running and accessible!" -ForegroundColor Green
    Write-Host "URL: http://localhost:8080" -ForegroundColor Cyan
} catch {
    Write-Host "Jenkins service is running but not accessible yet." -ForegroundColor Yellow
    Write-Host "Please wait a moment for Jenkins to fully start, then try again." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You can check Jenkins status with:" -ForegroundColor Cyan
    Write-Host "  Get-Service Jenkins" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "CI/CD Pipeline Configuration Steps" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 1: Access Jenkins Dashboard" -ForegroundColor Cyan
Write-Host "  Open your browser and go to: http://localhost:8080" -ForegroundColor White
Write-Host ""

# Get initial admin password
$initialPasswordPath = "$env:USERPROFILE\.jenkins\secrets\initialAdminPassword"
if (Test-Path $initialPasswordPath) {
    $initialPassword = Get-Content $initialPasswordPath -ErrorAction SilentlyContinue
    Write-Host "  Initial Admin Password: $initialPassword" -ForegroundColor Yellow
    Write-Host "  (Save this password - you'll need it to unlock Jenkins)" -ForegroundColor Gray
} else {
    Write-Host "  If this is your first time, get the initial password from:" -ForegroundColor Yellow
    Write-Host "  $initialPasswordPath" -ForegroundColor Gray
    Write-Host "  OR check the Jenkins service logs" -ForegroundColor Gray
}
Write-Host ""

Write-Host "STEP 2: Install Required Plugins" -ForegroundColor Cyan
Write-Host "  After unlocking Jenkins:" -ForegroundColor White
Write-Host "  1. Go to: Manage Jenkins -> Manage Plugins -> Available" -ForegroundColor White
Write-Host "  2. Search and install these plugins:" -ForegroundColor White
Write-Host "     - Git Plugin" -ForegroundColor Gray
Write-Host "     - Pipeline Plugin" -ForegroundColor Gray
Write-Host "     - Pipeline: Stage View Plugin" -ForegroundColor Gray
Write-Host "     - HTML Publisher Plugin" -ForegroundColor Gray
Write-Host "     - Test Results Analyzer Plugin" -ForegroundColor Gray
Write-Host "     - Coverage Plugin (optional)" -ForegroundColor Gray
Write-Host "  3. Click Install without restart (or Install and restart)" -ForegroundColor White
Write-Host ""

Write-Host "STEP 3: Configure Global Tools" -ForegroundColor Cyan
Write-Host "  1. Go to: Manage Jenkins -> Global Tool Configuration" -ForegroundColor White
Write-Host "  2. Configure JDK:" -ForegroundColor White
Write-Host "     - Click Add JDK" -ForegroundColor Gray
Write-Host "     - Name: JDK-17" -ForegroundColor Gray
Write-Host "     - JAVA_HOME: (find your Java installation path)" -ForegroundColor Gray
Write-Host ""
Write-Host "     To find Java path, run:" -ForegroundColor Yellow
Write-Host "       Get-ChildItem 'C:\Program Files\Java' -ErrorAction SilentlyContinue" -ForegroundColor Cyan
Write-Host "       Get-ChildItem 'C:\Program Files\Eclipse Adoptium' -ErrorAction SilentlyContinue" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. Configure Flutter:" -ForegroundColor White
Write-Host "     Option A: Add to PATH (Recommended)" -ForegroundColor Gray
Write-Host "       - Go to: Manage Jenkins -> Configure System" -ForegroundColor Gray
Write-Host "       - Find Global properties -> Environment variables" -ForegroundColor Gray
Write-Host "       - Add: PATH = C:\src\flutter\bin;%PATH%" -ForegroundColor Gray
Write-Host "       (Adjust path to your Flutter installation)" -ForegroundColor Gray
Write-Host ""
Write-Host "     Option B: Use Flutter Plugin (if installed)" -ForegroundColor Gray
Write-Host "       - In Global Tool Configuration" -ForegroundColor Gray
Write-Host "       - Add Flutter installation" -ForegroundColor Gray
Write-Host "       - Name: Flutter-Stable" -ForegroundColor Gray
Write-Host "       - Path: C:\src\flutter (or your Flutter path)" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 4: Create Pipeline Job" -ForegroundColor Cyan
Write-Host "  1. Click New Item on Jenkins dashboard" -ForegroundColor White
Write-Host "  2. Enter job name: Flutter-CI-CD" -ForegroundColor White
Write-Host "  3. Select Pipeline and click OK" -ForegroundColor White
Write-Host "  4. Configure the pipeline:" -ForegroundColor White
Write-Host ""
Write-Host "     Pipeline Section:" -ForegroundColor Yellow
Write-Host "     - Definition: Pipeline script from SCM" -ForegroundColor Gray
Write-Host "     - SCM: Git" -ForegroundColor Gray
Write-Host "     - Repository URL:" -ForegroundColor Gray
$currentPath = (Get-Location).Path
Write-Host "       For local repo: file:///$($currentPath.Replace('\', '/'))" -ForegroundColor Cyan
Write-Host "       OR use your Git repository URL" -ForegroundColor Cyan
Write-Host "     - Credentials: (leave empty for local, add for remote private repos)" -ForegroundColor Gray
Write-Host "     - Branches to build: */main or */master" -ForegroundColor Gray
Write-Host "     - Script Path: Jenkinsfile.windows" -ForegroundColor Cyan
Write-Host "       (This uses the Windows-compatible version)" -ForegroundColor Gray
Write-Host "  5. Click Save" -ForegroundColor White
Write-Host ""

Write-Host "STEP 5: Run Your First Build" -ForegroundColor Cyan
Write-Host "  1. On your pipeline job page, click Build Now" -ForegroundColor White
Write-Host "  2. Watch the build progress in the Stage View" -ForegroundColor White
Write-Host "  3. Click on the build number to see details" -ForegroundColor White
Write-Host "  4. Click Console Output to see full logs" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Quick Configuration Commands" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Find Flutter path:" -ForegroundColor Yellow
$flutterPath = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if ($flutterPath) {
    $flutterDir = Split-Path (Split-Path $flutterPath) -Parent
    Write-Host "  Flutter found at: $flutterDir" -ForegroundColor Green
    Write-Host "  Add this to Jenkins PATH: $flutterDir\bin" -ForegroundColor Cyan
} else {
    Write-Host "  Flutter not in PATH. Common locations:" -ForegroundColor Yellow
    Write-Host "    C:\src\flutter\bin" -ForegroundColor Gray
    Write-Host "    C:\flutter\bin" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Find Java path:" -ForegroundColor Yellow
$javaPaths = @(
    "C:\Program Files\Java",
    "C:\Program Files\Eclipse Adoptium",
    "C:\Program Files (x86)\Java"
)
$javaFound = $false
foreach ($path in $javaPaths) {
    if (Test-Path $path) {
        $jdkDirs = Get-ChildItem $path -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*jdk*" -or $_.Name -like "*java*" }
        if ($jdkDirs) {
            Write-Host "  Java found at: $($jdkDirs[0].FullName)" -ForegroundColor Green
            Write-Host "  Use this as JAVA_HOME in Jenkins" -ForegroundColor Cyan
            $javaFound = $true
            break
        }
    }
}
if (-not $javaFound) {
    Write-Host "  Java not found in common locations" -ForegroundColor Yellow
    Write-Host "  Check: Get-ChildItem 'C:\Program Files' -Filter '*java*' -Directory" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Pipeline Files" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your Jenkinsfile options:" -ForegroundColor Yellow
if (Test-Path "Jenkinsfile.windows") {
    Write-Host "  Jenkinsfile.windows - Windows compatible (RECOMMENDED)" -ForegroundColor Green
}
if (Test-Path "Jenkinsfile") {
    Write-Host "  Jenkinsfile - Unix/Linux compatible" -ForegroundColor Cyan
}
Write-Host ""

Write-Host "Test pipeline locally:" -ForegroundColor Yellow
Write-Host "  .\run-pipeline-locally.ps1" -ForegroundColor Cyan
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Next Steps" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open http://localhost:8080 in your browser" -ForegroundColor White
Write-Host "2. Follow the steps above to configure Jenkins" -ForegroundColor White
Write-Host "3. Create and run your first pipeline build" -ForegroundColor White
Write-Host ""
Write-Host "For detailed instructions, see:" -ForegroundColor Yellow
Write-Host "  - PIPELINE_SETUP.md" -ForegroundColor Cyan
Write-Host "  - JENKINS_WINDOWS_SETUP.md" -ForegroundColor Cyan
Write-Host ""

