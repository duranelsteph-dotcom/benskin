# 🔑 Configuration des Clés API Google - Guide Complet

## 📋 Étape 1 : Créer un projet Google Cloud

1. **Allez sur [Google Cloud Console](https://console.cloud.google.com/)**
2. **Connectez-vous** avec votre compte Google
3. **Créez un nouveau projet** ou sélectionnez un projet existant
   - Cliquez sur le sélecteur de projet en haut
   - Cliquez sur "Nouveau projet"
   - Nommez votre projet (ex: "MotoTaxi-App")
   - Cliquez sur "Créer"

## 🔧 Étape 2 : Activer les APIs nécessaires

Dans votre projet Google Cloud :

1. **Allez dans "APIs & Services" > "Library"**
2. **Recherchez et activez ces APIs :**
   - `Maps SDK for Android`
   - `Maps SDK for iOS` 
   - `Places API`
   - `Directions API`
   - `Geocoding API` (optionnel)

## 🗝️ Étape 3 : Créer les clés API

### 3.1 Créer une clé pour Android

1. **Allez dans "APIs & Services" > "Credentials"**
2. **Cliquez sur "Create Credentials" > "API Key"**
3. **Nommez votre clé** : "Android Maps Key"
4. **Cliquez sur "Restrict Key"**
5. **Sélectionnez "Android apps"**
6. **Ajoutez votre package** : `com.example.untitled2` (ou votre package)
7. **Ajoutez votre SHA-1 fingerprint** (voir ci-dessous)
8. **Sélectionnez les APIs** : Maps SDK for Android, Places API, Directions API
9. **Cliquez sur "Save"**

### 3.2 Créer une clé pour iOS

1. **Créez une nouvelle clé API**
2. **Nommez votre clé** : "iOS Maps Key"
3. **Cliquez sur "Restrict Key"**
4. **Sélectionnez "iOS apps"**
5. **Ajoutez votre Bundle ID** : `com.example.untitled2` (ou votre Bundle ID)
6. **Sélectionnez les APIs** : Maps SDK for iOS, Places API, Directions API
7. **Cliquez sur "Save"**

### 3.3 Créer une clé pour le serveur (Places/Directions)

1. **Créez une nouvelle clé API**
2. **Nommez votre clé** : "Server API Key"
3. **Cliquez sur "Restrict Key"**
4. **Sélectionnez "HTTP referrers"**
5. **Ajoutez vos domaines** : `localhost`, `127.0.0.1`
6. **Sélectionnez les APIs** : Places API, Directions API, Geocoding API
7. **Cliquez sur "Save"**

## 🔍 Étape 4 : Obtenir le SHA-1 Fingerprint (Android)

### Option A : Via Android Studio
1. Ouvrez Android Studio
2. Allez dans `File` > `Project Structure`
3. Sélectionnez `app` > `Signing`
4. Copiez le SHA-1 fingerprint

### Option B : Via ligne de commande
```bash
# Pour debug
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Pour release
keytool -list -v -keystore path/to/your/release.keystore -alias your-key-alias
```

## ⚙️ Étape 5 : Configurer l'application

### 5.1 Mettre à jour api_config.dart

Ouvrez `lib/config/api_config.dart` et remplacez :

```dart
class ApiConfig {
  // Remplacez par vos vraies clés
  static const String googleMapsApiKey = 'VOTRE_CLE_ANDROID_ICI';
  static const String googlePlacesApiKey = 'VOTRE_CLE_SERVEUR_ICI';
  static const String googleDirectionsApiKey = 'VOTRE_CLE_SERVEUR_ICI';
  
  // URLs des APIs
  static const String placesApiUrl = 'https://maps.googleapis.com/maps/api/place';
  static const String directionsApiUrl = 'https://maps.googleapis.com/maps/api/directions';
}
```

### 5.2 Mettre à jour AndroidManifest.xml

Ouvrez `android/app/src/main/AndroidManifest.xml` et remplacez :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_ANDROID_ICI" />
```

### 5.3 Configurer iOS (si nécessaire)

Pour iOS, ajoutez votre clé dans `ios/Runner/AppDelegate.swift` :

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("VOTRE_CLE_IOS_ICI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🧪 Étape 6 : Tester la configuration

1. **Installez les dépendances :**
   ```bash
   flutter pub get
   ```

2. **Testez sur Android :**
   ```bash
   flutter run -d android
   ```

3. **Testez sur iOS :**
   ```bash
   flutter run -d ios
   ```

4. **Testez sur Windows :**
   ```bash
   flutter run -d windows
   ```

## 🔒 Sécurité des clés API

### Bonnes pratiques :
- ✅ **Restreignez vos clés** par plateforme et API
- ✅ **Utilisez des clés différentes** pour dev/prod
- ✅ **Ne commitez jamais** vos clés dans le code
- ✅ **Surveillez l'utilisation** dans Google Cloud Console
- ✅ **Renouvelez régulièrement** vos clés

### Variables d'environnement (recommandé) :
```dart
// Utilisez flutter_dotenv pour charger depuis .env
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get googlePlacesApiKey => dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';
  static String get googleDirectionsApiKey => dotenv.env['GOOGLE_DIRECTIONS_API_KEY'] ?? '';
}
```

## 🐛 Dépannage

### Erreurs courantes :

1. **"API key not valid"** : Vérifiez que la clé est correcte et active
2. **"This API project is not authorized"** : Activez l'API dans Google Cloud Console
3. **"RefererNotAllowedMapError"** : Vérifiez les restrictions de votre clé
4. **"INVALID_REQUEST"** : Vérifiez le format de votre requête

### Vérification des clés :
```bash
# Testez votre clé Places API
curl "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurant&key=VOTRE_CLE"

# Testez votre clé Directions API  
curl "https://maps.googleapis.com/maps/api/directions/json?origin=Paris&destination=Lyon&key=VOTRE_CLE"
```

## 📞 Support

Si vous rencontrez des problèmes :
1. Consultez la [documentation Google Maps](https://developers.google.com/maps)
2. Vérifiez les [quotas et limites](https://console.cloud.google.com/apis/api/maps-android-backend.googleapis.com/quotas)
3. Consultez les [logs de l'application](https://console.cloud.google.com/logs)

---

**⚠️ Important :** Ne partagez jamais vos clés API publiquement et surveillez leur utilisation !
