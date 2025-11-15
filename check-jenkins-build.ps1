# Check Jenkins Build Status and APK Location

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins Build Verification" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Issue Detected:" -ForegroundColor Yellow
Write-Host "  The build only did checkout - pipeline stages didn't run!" -ForegroundColor Red
Write-Host ""

Write-Host "Possible Causes:" -ForegroundColor Yellow
Write-Host "  1. Jenkinsfile not found in repository" -ForegroundColor White
Write-Host "  2. Script Path in Jenkins job is incorrect" -ForegroundColor White
Write-Host "  3. Pipeline not configured correctly" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 1: Verify Jenkinsfile in Git" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Jenkinsfile is tracked by Git
$jenkinsfiles = @("Jenkinsfile", "Jenkinsfile.windows")
foreach ($file in $jenkinsfiles) {
    if (Test-Path $file) {
        $gitStatus = git ls-files $file 2>$null
        if ($gitStatus) {
            Write-Host "  $file : In Git repository" -ForegroundColor Green
        } else {
            Write-Host "  $file : NOT in Git (needs to be committed)" -ForegroundColor Red
            Write-Host "    Run: git add $file" -ForegroundColor Yellow
            Write-Host "    Run: git commit -m 'Add $file'" -ForegroundColor Yellow
            Write-Host "    Run: git push" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 2: Check Jenkins Job Configuration" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "In Jenkins job configuration:" -ForegroundColor Yellow
Write-Host "  1. Go to: http://localhost:8080" -ForegroundColor White
Write-Host "  2. Click on: Flutter-CI_CD job" -ForegroundColor White
Write-Host "  3. Click: Configure" -ForegroundColor White
Write-Host "  4. Scroll to Pipeline section" -ForegroundColor White
Write-Host "  5. Verify:" -ForegroundColor White
Write-Host "     - Definition: Pipeline script from SCM" -ForegroundColor Cyan
Write-Host "     - SCM: Git" -ForegroundColor Cyan
Write-Host "     - Repository URL: https://github.com/sunilkrsingh8922/ciandcd.git" -ForegroundColor Cyan
Write-Host "     - Script Path: Jenkinsfile.windows" -ForegroundColor Cyan
Write-Host "       OR: Jenkinsfile (if you renamed it)" -ForegroundColor Gray
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 3: Check Build Console Output" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "In Jenkins:" -ForegroundColor Yellow
Write-Host "  1. Click on the build number" -ForegroundColor White
Write-Host "  2. Click: Console Output" -ForegroundColor White
Write-Host "  3. Look for:" -ForegroundColor White
Write-Host "     - 'Loading Jenkinsfile...' message" -ForegroundColor Cyan
Write-Host "     - Pipeline stages (Checkout, Setup Flutter, etc.)" -ForegroundColor Cyan
Write-Host "     - Any error messages" -ForegroundColor Cyan
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 4: Check APK Build Location" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If APK was built, check these locations:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Jenkins Workspace:" -ForegroundColor Cyan
Write-Host "  C:\ProgramData\Jenkins\.jenkins\workspace\Flutter-CI_CD\build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""
Write-Host "Build Artifacts (in Jenkins):" -ForegroundColor Cyan
Write-Host "  1. Go to build page in Jenkins" -ForegroundColor White
Write-Host "  2. Look for 'Artifacts' section" -ForegroundColor White
Write-Host "  3. Download the APK file" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Quick Fix Commands" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "If Jenkinsfile.windows is not in Git:" -ForegroundColor Yellow
Write-Host "  git add Jenkinsfile.windows" -ForegroundColor Cyan
Write-Host "  git commit -m 'Add Jenkinsfile for CI/CD'" -ForegroundColor Cyan
Write-Host "  git push origin main" -ForegroundColor Cyan
Write-Host ""

Write-Host "Check if APK exists in workspace:" -ForegroundColor Yellow
Write-Host "  Test-Path 'C:\ProgramData\Jenkins\.jenkins\workspace\Flutter-CI_CD\build\app\outputs\flutter-apk\app-release.apk'" -ForegroundColor Cyan
Write-Host ""

