@echo off
echo 🔑 Configuration automatique des clés API Google
echo ================================================
echo.

echo 📋 Étapes à suivre :
echo 1. Ouvrir Google Cloud Console
echo 2. Créer un projet
echo 3. Activer les APIs
echo 4. Créer les clés API
echo 5. Configurer l'application
echo.

echo 🌐 Ouverture de Google Cloud Console...
start https://console.cloud.google.com/

echo.
echo ⏳ Appuyez sur Entrée quand vous avez terminé la configuration sur Google Cloud...
pause

echo.
echo 🔧 Configuration de l'application...
echo.

set /p android_key="Entrez votre clé API Android : "
set /p server_key="Entrez votre clé API Serveur (Places/Directions) : "

echo.
echo 📝 Mise à jour des fichiers de configuration...

:: Mettre à jour api_config.dart
powershell -Command "(Get-Content 'lib\config\api_config.dart') -replace 'YOUR_GOOGLE_MAPS_API_KEY_HERE', '%android_key%' | Set-Content 'lib\config\api_config.dart'"
powershell -Command "(Get-Content 'lib\config\api_config.dart') -replace 'YOUR_GOOGLE_PLACES_API_KEY_HERE', '%server_key%' | Set-Content 'lib\config\api_config.dart'"
powershell -Command "(Get-Content 'lib\config\api_config.dart') -replace 'YOUR_GOOGLE_DIRECTIONS_API_KEY_HERE', '%server_key%' | Set-Content 'lib\config\api_config.dart'"

:: Mettre à jour AndroidManifest.xml
powershell -Command "(Get-Content 'android\app\src\main\AndroidManifest.xml') -replace 'YOUR_GOOGLE_MAPS_API_KEY_HERE', '%android_key%' | Set-Content 'android\app\src\main\AndroidManifest.xml'"

echo ✅ Configuration terminée !
echo.
echo 🚀 Prochaines étapes :
echo 1. flutter pub get
echo 2. flutter run -d android
echo.
echo Appuyez sur Entrée pour continuer...
pause
