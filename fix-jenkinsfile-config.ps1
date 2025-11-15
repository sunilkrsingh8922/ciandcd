# Quick Fix for Jenkinsfile Not Showing in Jenkins

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkinsfile Configuration Fix" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Verify files
Write-Host "Checking Jenkinsfile files..." -ForegroundColor Yellow
$files = @("Jenkinsfile", "Jenkinsfile.windows")
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  $file : EXISTS" -ForegroundColor Green
    } else {
        Write-Host "  $file : NOT FOUND" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins Job Configuration Steps" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 1: Open Jenkins Job Configuration" -ForegroundColor Cyan
Write-Host "  1. Go to: http://localhost:8080" -ForegroundColor White
Write-Host "  2. Click on your pipeline job (or create new one)" -ForegroundColor White
Write-Host "  3. Click Configure" -ForegroundColor White
Write-Host ""

Write-Host "STEP 2: Configure Pipeline Section" -ForegroundColor Cyan
Write-Host "  Scroll to Pipeline section and set:" -ForegroundColor White
Write-Host ""
Write-Host "  Definition: Pipeline script from SCM" -ForegroundColor Yellow
Write-Host "  SCM: Git" -ForegroundColor Yellow
Write-Host ""

# Get current directory path
$currentPath = (Get-Location).Path
$filePath = $currentPath.Replace('\', '/')

Write-Host "  Repository URL:" -ForegroundColor Yellow
Write-Host "    Option A (Local): file:///$filePath" -ForegroundColor Cyan
Write-Host "    Option B (Git): Your Git repository URL" -ForegroundColor Cyan
Write-Host ""

Write-Host "  Credentials: (leave empty for local, add for remote)" -ForegroundColor Yellow
Write-Host ""

Write-Host "  Branches to build:" -ForegroundColor Yellow
Write-Host "    */main" -ForegroundColor Cyan
Write-Host "    OR */master" -ForegroundColor Cyan
Write-Host "    OR * (all branches)" -ForegroundColor Cyan
Write-Host ""

Write-Host "  Script Path: Jenkinsfile.windows" -ForegroundColor Yellow
Write-Host "    (Must match exactly, case-sensitive)" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 3: Save and Test" -ForegroundColor Cyan
Write-Host "  1. Click Save" -ForegroundColor White
Write-Host "  2. Click Build Now" -ForegroundColor White
Write-Host "  3. Check Console Output for errors" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Alternative: Use Inline Pipeline" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If file path issues persist, use inline pipeline:" -ForegroundColor Yellow
Write-Host "  1. In Pipeline section, select: Pipeline script" -ForegroundColor White
Write-Host "  2. Copy the contents of Jenkinsfile.windows" -ForegroundColor White
Write-Host "  3. Paste into the script box" -ForegroundColor White
Write-Host "  4. Save and build" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Common Errors and Fixes" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Error: 'Jenkinsfile not found'" -ForegroundColor Red
Write-Host "  Fix: Check Script Path is exactly: Jenkinsfile.windows" -ForegroundColor Yellow
Write-Host "  Fix: Verify Repository URL is correct" -ForegroundColor Yellow
Write-Host ""

Write-Host "Error: 'SCM checkout failed'" -ForegroundColor Red
Write-Host "  Fix: If using file:///, ensure Jenkins has read permissions" -ForegroundColor Yellow
Write-Host "  Fix: Try using Git repository instead" -ForegroundColor Yellow
Write-Host ""

Write-Host "Error: 'Script path not found'" -ForegroundColor Red
Write-Host "  Fix: Script Path must match filename exactly" -ForegroundColor Yellow
Write-Host "  Fix: No leading slash, no file extension issues" -ForegroundColor Yellow
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Quick Copy Commands" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Repository URL (Local):" -ForegroundColor Yellow
Write-Host "  file:///$filePath" -ForegroundColor Cyan
Write-Host ""

Write-Host "Script Path:" -ForegroundColor Yellow
Write-Host "  Jenkinsfile.windows" -ForegroundColor Cyan
Write-Host ""

Write-Host "To copy Jenkinsfile content for inline use:" -ForegroundColor Yellow
Write-Host "  Get-Content Jenkinsfile.windows | Set-Clipboard" -ForegroundColor Cyan
Write-Host ""

