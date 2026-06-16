# PowerShell helper to clean, get packages, and run the Flutter web app
# Run this from the project's root directory in PowerShell

Write-Host "Cleaning project..."
flutter clean

Write-Host "Getting packages..."
flutter pub get

Write-Host "Running on Chrome..."
flutter run -d chrome

if ($LASTEXITCODE -ne 0) {
  Write-Host "flutter run failed. See output above. Common fixes:"
  Write-Host "- Check WEB_BUILD_INSTRUCTIONS.md"
  Write-Host "- If errors reference firebase_*_web, consider pinning web packages under dependency_overrides in pubspec.yaml"
}
