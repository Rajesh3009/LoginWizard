
# Get name and version from pubspec.yaml using regex
$pubspecContent = Get-Content "pubspec.yaml"

$appName = ($pubspecContent | Select-String "^name:\s*(.*)").Matches.Groups[1].Value.Trim()
# Only take the version before the '+'
$fullVersion = ($pubspecContent | Select-String "^version:\s*(.*)").Matches.Groups[1].Value.Trim()
$version = $fullVersion.Split("+")[0]

Write-Host "Detected App Name: $appName"
Write-Host "Detected Version: $version"

# Create output directory
$outputDir = Join-Path (Get-Location) "releases"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# 1. Build APK (Split per ABI to get arch-specific files)
Write-Host "--- Building APK (Split per ABI) ---"
flutter build apk --release --split-per-abi
if ($LASTEXITCODE -eq 0) {
    $apkSourceDir = "build\app\outputs\flutter-apk"
    Get-ChildItem -Path $apkSourceDir -Filter "app-*-release.apk" | ForEach-Object {
        $arch = $_.Name.Replace("app-", "").Replace("-release.apk", "")
        # Standardize arch names if needed (e.g., armeabi-v7a, arm64-v8a, x86_64)
        Copy-Item $_.FullName "$outputDir\${appName}_${version}_${arch}.apk"
        Write-Host "SUCCESS: APK ($arch) copied to $outputDir"
    }
} else {
    Write-Host "ERROR: APK build failed" -ForegroundColor Red
}

# 2. Build AAB
Write-Host "--- Building AAB ---"
flutter build appbundle --release
if ($LASTEXITCODE -eq 0) {
    Copy-Item "build\app\outputs\bundle\release\app-release.aab" "$outputDir\${appName}_${version}_Android.aab"
    Write-Host "SUCCESS: AAB copied to $outputDir"
} else {
    Write-Host "ERROR: AAB build failed" -ForegroundColor Red
}

# 3. Build Windows
Write-Host "--- Building Windows ---"
flutter build windows --release
if ($LASTEXITCODE -eq 0) {
    $windowsBuildPath = "build\windows\x64\runner\Release"
    $zipPath = "$outputDir\${appName}_${version}_Win.zip"
    
    if (Test-Path $zipPath) { Remove-Item $zipPath }
    
    Compress-Archive -Path "$windowsBuildPath\*" -DestinationPath $zipPath -Force
    Write-Host "SUCCESS: Windows ZIP created at $zipPath"
} else {
    Write-Host "ERROR: Windows build failed" -ForegroundColor Red
}

# 4. Build Windows Installer
Write-Host "--- Building Windows Installer ---"
dart run inno_bundle:build --release
if ($LASTEXITCODE -eq 0) {
    $installerSourceDir = "build\windows\x64\installer\release"
    Get-ChildItem -Path $installerSourceDir -Filter "*.exe" | ForEach-Object {
        Copy-Item $_.FullName "$outputDir\${appName}_${version}_Installer.exe"
        Write-Host "SUCCESS: Windows Installer copied to $outputDir"
    }
} else {
    Write-Host "ERROR: Windows Installer build failed" -ForegroundColor Red
}

Write-Host "`nAll tasks attempted. Check $outputDir for results."
