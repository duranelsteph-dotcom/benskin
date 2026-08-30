# 🚀 Guide de Démarrage Rapide - Géolocalisation

## ⚡ Configuration en 5 minutes

### 1. Obtenir les clés API Google

1. **Allez sur [Google Cloud Console](https://console.cloud.google.com/)**
2. **Créez un projet** (ou sélectionnez un existant)
3. **Activez ces APIs :**
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Directions API

4. **Créez 2 clés API :**
   - **Clé Android** : Restreinte aux apps Android
   - **Clé Serveur** : Pour Places API et Directions API

### 2. Configurer l'application

**Option A : Script automatique**
```bash
dart configure_api_keys.dart
```

**Option B : Configuration manuelle**

1. **Ouvrez `lib/config/api_config.dart`**
2. **Remplacez les clés :**
   ```dart
   static const String googleMapsApiKey = 'VOTRE_CLE_ANDROID';
   static const String googlePlacesApiKey = 'VOTRE_CLE_SERVEUR';
   static const String googleDirectionsApiKey = 'VOTRE_CLE_SERVEUR';
   ```

3. **Ouvrez `android/app/src/main/AndroidManifest.xml`**
4. **Remplacez la clé :**
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="VOTRE_CLE_ANDROID" />
   ```

### 3. Installer et tester

```bash
# Installer les dépendances
flutter pub get

# Tester sur Android
flutter run -d android

# Tester sur iOS
flutter run -d ios

# Tester sur Windows
flutter run -d windows
```

### 4. Vérifier la configuration

```bash
dart verify_configuration.dart
```

## 🎯 Utilisation

### Accéder à la carte
```dart
Navigator.of(context).pushNamed('/maps');
```

### Utiliser les services
```dart
// Géolocalisation
final locationService = LocationService();
final position = await locationService.getCurrentPosition();

// Recherche de lieux
final placesService = PlacesService();
final places = await placesService.searchPlaces('restaurant');

// Calcul d'itinéraires
final directionsService = DirectionsService();
final route = await directionsService.getDirections(
  startLat, startLng, endLat, endLng,
);
```

## 🔧 Dépannage rapide

| Problème | Solution |
|----------|----------|
| Carte ne s'affiche pas | Vérifiez la clé API Android |
| Position non détectée | Vérifiez les permissions |
| Recherche ne fonctionne pas | Vérifiez la clé Places API |
| Itinéraires non calculés | Vérifiez la clé Directions API |

## 📚 Documentation complète

- **Configuration détaillée** : `CONFIGURATION_API_KEYS.md`
- **Guide d'utilisation** : `GEOLOCATION_README.md`
- **Exemple de code** : `lib/examples/maps_example.dart`

## 🆘 Support

Si vous rencontrez des problèmes :
1. Vérifiez que vos clés API sont correctes
2. Assurez-vous que les APIs sont activées
3. Vérifiez les permissions de localisation
4. Consultez les logs de l'application

---

**🎉 Félicitations !** Votre application de géolocalisation est maintenant prête !
