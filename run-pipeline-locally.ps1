# Run CI/CD Pipeline Steps Locally (Without Jenkins)
# This script simulates the Jenkins pipeline steps

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Running CI/CD Pipeline Steps Locally" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check Flutter
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
flutter --version | Out-Null
if ($LASTEXITCODE -eq 0) {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "Flutter found: $flutterVersion" -ForegroundColor Green
} else {
    Write-Host "Flutter not found. Please install Flutter first." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Stage 1: Get Dependencies" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to get dependencies" -ForegroundColor Red
    exit 1
}
flutter pub upgrade

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Stage 2: Code Analysis" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
flutter analyze --no-fatal-infos
if ($LASTEXITCODE -ne 0) {
    Write-Host "Code analysis found issues (non-fatal)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Stage 3: Run Tests" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
flutter test --coverage
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All tests passed!" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Stage 4: Build Android APK" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
flutter build apk --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "APK build failed" -ForegroundColor Red
    exit 1
} else {
    Write-Host "APK built successfully!" -ForegroundColor Green
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length / 1MB
        Write-Host "Location: $apkPath" -ForegroundColor Gray
        Write-Host "Size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Pipeline Completed Successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
