# Fonctionnalité de Géolocalisation - Guide d'implémentation

Cette application Flutter inclut une fonctionnalité complète de géolocalisation avec Google Maps, recherche de lieux et calcul d'itinéraires.

## 🚀 Fonctionnalités

- **Détection de position en temps réel** avec permissions automatiques
- **Suivi des déplacements** avec mise à jour continue
- **Recherche de destinations** via Google Places API
- **Calcul d'itinéraires** avec Google Directions API
- **Affichage sur Google Maps** avec marqueurs et polylines
- **Support multi-plateforme** : Android, iOS et Windows

## 📋 Prérequis

### 1. Clés API Google

Vous devez obtenir les clés API suivantes depuis [Google Cloud Console](https://console.cloud.google.com/) :

- **Maps SDK for Android** - Pour afficher les cartes sur Android
- **Maps SDK for iOS** - Pour afficher les cartes sur iOS  
- **Places API** - Pour la recherche de lieux
- **Directions API** - Pour le calcul d'itinéraires

### 2. Configuration des clés

Ouvrez `lib/config/api_config.dart` et remplacez les clés par vos vraies clés :

```dart
class ApiConfig {
  static const String googleMapsApiKey = 'VOTRE_CLE_MAPS_ICI';
  static const String googlePlacesApiKey = 'VOTRE_CLE_PLACES_ICI';
  static const String googleDirectionsApiKey = 'VOTRE_CLE_DIRECTIONS_ICI';
}
```

### 3. Configuration Android

Les permissions sont déjà configurées dans `android/app/src/main/AndroidManifest.xml` :

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

Ajoutez votre clé API dans le manifest :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_MAPS_ICI" />
```

### 4. Configuration iOS

Les permissions sont configurées dans `ios/Runner/Info.plist` :

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Cette application a besoin d'accéder à votre position pour afficher votre localisation sur la carte et calculer des itinéraires.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Cette application a besoin d'accéder à votre position pour suivre vos déplacements en temps réel et calculer des itinéraires.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Cette application a besoin d'accéder à votre position en arrière-plan pour suivre vos déplacements.</string>
```

## 🏗️ Architecture

### Services

- **LocationService** (`lib/services/location_service.dart`) : Gestion de la géolocalisation
- **PlacesService** (`lib/services/places_service.dart`) : Recherche de lieux via Google Places
- **DirectionsService** (`lib/services/directions_service.dart`) : Calcul d'itinéraires

### Pages

- **MapsPage** (`lib/pages/maps_page.dart`) : Page principale avec Google Maps
- **MapsExample** (`lib/examples/maps_example.dart`) : Exemple d'utilisation

### Widgets

- **PlaceSearchWidget** (`lib/widgets/place_search_widget.dart`) : Widget de recherche de lieux
- **RouteInfoWidget** (`lib/widgets/route_info_widget.dart`) : Affichage des informations d'itinéraire

## 🚀 Utilisation

### Navigation vers la carte

```dart
Navigator.of(context).pushNamed('/maps');
```

### Utilisation des services

```dart
// Service de géolocalisation
final locationService = LocationService();

// Obtenir la position actuelle
final position = await locationService.getCurrentPosition();

// Démarrer le suivi
await locationService.startLocationTracking();

// Écouter les changements de position
locationService.positionStream.listen((position) {
  print('Nouvelle position: ${position.latitude}, ${position.longitude}');
});

// Service de recherche de lieux
final placesService = PlacesService();
final places = await placesService.searchPlaces('restaurant');

// Service de directions
final directionsService = DirectionsService();
final route = await directionsService.getDirections(
  startLat, startLng, endLat, endLng,
);
```

## 🔧 Personnalisation

### Modifier la précision de localisation

Dans `LocationService`, modifiez `LocationAccuracy` :

```dart
const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high, // ou .medium, .low
  distanceFilter: 10, // Mettre à jour toutes les 10 mètres
);
```

### Modifier le style de la carte

Dans `MapsPage`, changez le type de carte :

```dart
GoogleMap(
  mapType: MapType.normal, // ou .satellite, .terrain, .hybrid
  // ...
)
```

### Personnaliser les marqueurs

```dart
Marker(
  markerId: const MarkerId('custom_marker'),
  position: LatLng(lat, lng),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  infoWindow: const InfoWindow(
    title: 'Mon marqueur',
    snippet: 'Description',
  ),
)
```

## 🐛 Dépannage

### Problèmes courants

1. **Carte ne s'affiche pas** : Vérifiez que votre clé API est correcte
2. **Position non détectée** : Vérifiez les permissions de localisation
3. **Recherche ne fonctionne pas** : Vérifiez la clé Places API
4. **Itinéraires non calculés** : Vérifiez la clé Directions API

### Logs de débogage

Activez les logs pour diagnostiquer les problèmes :

```dart
// Dans LocationService
print('Position actuelle: ${position.latitude}, ${position.longitude}');

// Dans PlacesService  
print('Résultats de recherche: ${results.length}');

// Dans DirectionsService
print('Itinéraire calculé: ${route.distance}');
```

## 📱 Test sur différentes plateformes

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Windows
```bash
flutter run -d windows
```

## 🔒 Sécurité

- Ne commitez jamais vos clés API dans le code source
- Utilisez des restrictions de clés API appropriées
- Considérez l'utilisation de variables d'environnement pour la production

## 📚 Ressources

- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Geolocator Plugin](https://pub.dev/packages/geolocator)
- [Google Places API](https://developers.google.com/maps/documentation/places)
- [Google Directions API](https://developers.google.com/maps/documentation/directions)
