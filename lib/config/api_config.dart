// Configuration des clés API
class ApiConfig {
  // ⚠️  IMPORTANT: Remplacez ces valeurs par vos vraies clés API Google
  // 
  // Pour obtenir vos clés :
  // 1. Allez sur https://console.cloud.google.com/
  // 2. Créez un projet ou sélectionnez un existant
  // 3. Activez les APIs : Maps SDK, Places API, Directions API
  // 4. Créez des clés API avec restrictions appropriées
  // 5. Remplacez les valeurs ci-dessous
  //
  // Consultez CONFIGURATION_API_KEYS.md pour un guide détaillé
  
  // ⚠️ CLÉS DE TEST TEMPORAIRES - Remplacez par vos vraies clés API
  static const String googleMapsApiKey = 'AIzaSyBvOkBw7cItYl5OI4SPI2Np3C3nR6vT8uE'; // Clé de test
  static const String googlePlacesApiKey = 'AIzaSyBvOkBw7cItYl5OI4SPI2Np3C3nR6vT8uE'; // Clé de test
  static const String googleDirectionsApiKey = 'AIzaSyBvOkBw7cItYl5OI4SPI2Np3C3nR6vT8uE'; // Clé de test
  
  // URLs des APIs
  static const String placesApiUrl = 'https://maps.googleapis.com/maps/api/place';
  static const String directionsApiUrl = 'https://maps.googleapis.com/maps/api/directions';
  
  // Note: Pour obtenir ces clés, visitez:
  // https://console.cloud.google.com/
  // 1. Créez un nouveau projet ou sélectionnez un projet existant
  // 2. Activez les APIs suivantes:
  //    - Maps SDK for Android
  //    - Maps SDK for iOS
  //    - Places API
  //    - Directions API
  // 3. Créez des clés API avec les restrictions appropriées
}
