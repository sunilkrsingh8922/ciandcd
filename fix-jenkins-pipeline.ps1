# Fix Jenkins Pipeline - APK Not Building

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins Pipeline Fix - APK Build Issue" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "PROBLEM IDENTIFIED:" -ForegroundColor Red
Write-Host "  Build only did checkout - pipeline stages didn't run!" -ForegroundColor Yellow
Write-Host "  This means Jenkinsfile was not loaded/executed" -ForegroundColor Yellow
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "SOLUTION: Fix Jenkins Job Configuration" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 1: Open Jenkins Job Configuration" -ForegroundColor Yellow
Write-Host "  1. Go to: http://localhost:8080" -ForegroundColor White
Write-Host "  2. Click on: Flutter-CI_CD" -ForegroundColor White
Write-Host "  3. Click: Configure" -ForegroundColor White
Write-Host ""

Write-Host "STEP 2: Check Pipeline Configuration" -ForegroundColor Yellow
Write-Host "  Scroll to 'Pipeline' section and verify:" -ForegroundColor White
Write-Host ""
Write-Host "  Definition: Pipeline script from SCM" -ForegroundColor Cyan
Write-Host "  SCM: Git" -ForegroundColor Cyan
Write-Host "  Repository URL: https://github.com/sunilkrsingh8922/ciandcd.git" -ForegroundColor Cyan
Write-Host "  Credentials: (your GitHub credentials)" -ForegroundColor Cyan
Write-Host "  Branches to build: */main" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Script Path: Jenkinsfile.windows" -ForegroundColor Green
Write-Host "    ^^^ THIS IS CRITICAL - Must match exactly!" -ForegroundColor Yellow
Write-Host ""

Write-Host "STEP 3: Alternative - Use Default Jenkinsfile" -ForegroundColor Yellow
Write-Host "  If Jenkinsfile.windows doesn't work, try:" -ForegroundColor White
Write-Host "  Script Path: Jenkinsfile" -ForegroundColor Cyan
Write-Host "  (This uses the Unix-compatible version)" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 4: Save and Rebuild" -ForegroundColor Yellow
Write-Host "  1. Click Save" -ForegroundColor White
Write-Host "  2. Click Build Now" -ForegroundColor White
Write-Host "  3. Watch the build - you should see pipeline stages!" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Expected Build Stages" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "When working correctly, you should see:" -ForegroundColor Yellow
Write-Host "  [Pipeline] stage (Checkout)" -ForegroundColor Green
Write-Host "  [Pipeline] stage (Setup Flutter)" -ForegroundColor Green
Write-Host "  [Pipeline] stage (Get Dependencies)" -ForegroundColor Green
Write-Host "  [Pipeline] stage (Code Analysis)" -ForegroundColor Green
Write-Host "  [Pipeline] stage (Run Tests)" -ForegroundColor Green
Write-Host "  [Pipeline] stage (Build Android APK)" -ForegroundColor Green
Write-Host "  [Pipeline] stage (Build Android App Bundle)" -ForegroundColor Green
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Check APK After Successful Build" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "After build completes successfully:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Option 1: In Jenkins Web UI" -ForegroundColor Cyan
Write-Host "  1. Go to build page" -ForegroundColor White
Write-Host "  2. Scroll down to 'Artifacts' section" -ForegroundColor White
Write-Host "  3. Click on app-release.apk to download" -ForegroundColor White
Write-Host ""
Write-Host "Option 2: Check Workspace Directory" -ForegroundColor Cyan
Write-Host "  Location: C:\ProgramData\Jenkins\.jenkins\workspace\Flutter-CI_CD\build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""
Write-Host "Check if APK exists:" -ForegroundColor Yellow
Write-Host "  Test-Path 'C:\ProgramData\Jenkins\.jenkins\workspace\Flutter-CI_CD\build\app\outputs\flutter-apk\app-release.apk'" -ForegroundColor Cyan
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Troubleshooting" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If Script Path doesn't work:" -ForegroundColor Yellow
Write-Host "  1. Check Console Output for error messages" -ForegroundColor White
Write-Host "  2. Look for 'Jenkinsfile not found' error" -ForegroundColor White
Write-Host "  3. Try using 'Jenkinsfile' instead of 'Jenkinsfile.windows'" -ForegroundColor White
Write-Host "  4. Or use inline pipeline (paste Jenkinsfile content directly)" -ForegroundColor White
Write-Host ""

Write-Host "If build still only does checkout:" -ForegroundColor Yellow
Write-Host "  1. Verify Jenkinsfile.windows is in GitHub repository" -ForegroundColor White
Write-Host "  2. Check branch name matches (main vs master)" -ForegroundColor White
Write-Host "  3. Verify Git credentials are correct" -ForegroundColor White
Write-Host ""

