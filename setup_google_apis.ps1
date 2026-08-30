# Script PowerShell pour configurer automatiquement les clés API Google
# Usage: .\setup_google_apis.ps1

Write-Host "🔑 Configuration automatique des clés API Google" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan
Write-Host ""

# Vérifier si les fichiers existent
$configFile = "lib\config\api_config.dart"
$manifestFile = "android\app\src\main\AndroidManifest.xml"

if (-not (Test-Path $configFile)) {
    Write-Host "❌ Fichier de configuration non trouvé: $configFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $manifestFile)) {
    Write-Host "❌ Fichier AndroidManifest.xml non trouvé: $manifestFile" -ForegroundColor Red
    exit 1
}

Write-Host "📋 Instructions de configuration :" -ForegroundColor Yellow
Write-Host "1. Allez sur https://console.cloud.google.com/" -ForegroundColor White
Write-Host "2. Créez un projet ou sélectionnez un existant" -ForegroundColor White
Write-Host "3. Activez ces APIs :" -ForegroundColor White
Write-Host "   • Maps SDK for Android" -ForegroundColor Gray
Write-Host "   • Maps SDK for iOS" -ForegroundColor Gray
Write-Host "   • Places API" -ForegroundColor Gray
Write-Host "   • Directions API" -ForegroundColor Gray
Write-Host "4. Créez 2 clés API :" -ForegroundColor White
Write-Host "   • Clé Android (restreinte aux apps Android)" -ForegroundColor Gray
Write-Host "   • Clé Serveur (pour Places API et Directions API)" -ForegroundColor Gray
Write-Host ""

# Ouvrir Google Cloud Console
Write-Host "🌐 Ouverture de Google Cloud Console..." -ForegroundColor Green
Start-Process "https://console.cloud.google.com/"

Write-Host ""
Write-Host "⏳ Appuyez sur Entrée quand vous avez terminé la configuration sur Google Cloud..." -ForegroundColor Yellow
Read-Host

# Demander les clés API
Write-Host ""
Write-Host "🔑 Saisissez vos clés API :" -ForegroundColor Cyan

$androidKey = Read-Host "Clé API Android"
$serverKey = Read-Host "Clé API Serveur (Places/Directions)"

if ([string]::IsNullOrWhiteSpace($androidKey) -or [string]::IsNullOrWhiteSpace($serverKey)) {
    Write-Host "❌ Les clés API sont obligatoires !" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔧 Configuration de l'application..." -ForegroundColor Green

# Mettre à jour api_config.dart
Write-Host "📝 Mise à jour de lib\config\api_config.dart..." -ForegroundColor Yellow
$configContent = Get-Content $configFile -Raw
$configContent = $configContent -replace 'YOUR_GOOGLE_MAPS_API_KEY_HERE', $androidKey
$configContent = $configContent -replace 'YOUR_GOOGLE_PLACES_API_KEY_HERE', $serverKey
$configContent = $configContent -replace 'YOUR_GOOGLE_DIRECTIONS_API_KEY_HERE', $serverKey
Set-Content $configFile $configContent -Encoding UTF8

# Mettre à jour AndroidManifest.xml
Write-Host "📝 Mise à jour de android\app\src\main\AndroidManifest.xml..." -ForegroundColor Yellow
$manifestContent = Get-Content $manifestFile -Raw
$manifestContent = $manifestContent -replace 'YOUR_GOOGLE_MAPS_API_KEY_HERE', $androidKey
Set-Content $manifestFile $manifestContent -Encoding UTF8

Write-Host ""
Write-Host "✅ Configuration terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Prochaines étapes :" -ForegroundColor Cyan
Write-Host "1. flutter pub get" -ForegroundColor White
Write-Host "2. flutter run -d android" -ForegroundColor White
Write-Host "3. Testez la fonctionnalité de géolocalisation" -ForegroundColor White
Write-Host ""

# Proposer d'exécuter flutter pub get
$runFlutter = Read-Host "Voulez-vous exécuter 'flutter pub get' maintenant ? (y/n)"
if ($runFlutter -eq "y" -or $runFlutter -eq "Y") {
    Write-Host "🔄 Exécution de flutter pub get..." -ForegroundColor Green
    flutter pub get
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ flutter pub get terminé avec succès !" -ForegroundColor Green
    } else {
        Write-Host "❌ Erreur lors de l'exécution de flutter pub get" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 Configuration terminée ! Votre application est prête." -ForegroundColor Green
Write-Host "📚 Consultez GEOLOCATION_README.md pour plus de details" -ForegroundColor Gray
