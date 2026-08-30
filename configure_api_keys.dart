#!/usr/bin/env dart

/// Script interactif pour configurer les clés API Google
/// 
/// Ce script vous guide étape par étape pour configurer vos clés API.
/// 
/// Usage: dart configure_api_keys.dart

import 'dart:io';

void main() async {
  print('🔑 Configuration des Clés API Google');
  print('=' * 50);
  
  // Vérifier si les fichiers existent
  final configFile = File('lib/config/api_config.dart');
  final androidManifest = File('android/app/src/main/AndroidManifest.xml');
  
  if (!configFile.existsSync()) {
    print('❌ Fichier de configuration non trouvé: lib/config/api_config.dart');
    return;
  }
  
  print('\n📋 Informations nécessaires :');
  print('1. Clé API Android (Maps SDK for Android)');
  print('2. Clé API iOS (Maps SDK for iOS) - optionnel');
  print('3. Clé API Serveur (Places API + Directions API)');
  
  print('\n🌐 Obtenez vos clés sur: https://console.cloud.google.com/');
  print('   • Créez un projet ou sélectionnez un existant');
  print('   • Activez les APIs: Maps SDK, Places API, Directions API');
  print('   • Créez des clés API avec restrictions appropriées');
  
  // Demander les clés
  print('\n🔑 Saisissez vos clés API :');
  
  stdout.write('Clé API Android: ');
  final androidKey = stdin.readLineSync()?.trim() ?? '';
  
  stdout.write('Clé API Serveur (Places/Directions): ');
  final serverKey = stdin.readLineSync()?.trim() ?? '';
  
  stdout.write('Clé API iOS (optionnel): ');
  final iosKey = stdin.readLineSync()?.trim() ?? '';
  
  if (androidKey.isEmpty || serverKey.isEmpty) {
    print('\n❌ Les clés Android et Serveur sont obligatoires !');
    return;
  }
  
  // Mettre à jour le fichier de configuration
  await updateApiConfig(androidKey, serverKey, iosKey);
  
  // Mettre à jour AndroidManifest.xml
  await updateAndroidManifest(androidKey);
  
  print('\n✅ Configuration terminée !');
  print('\n📝 Prochaines étapes :');
  print('1. flutter pub get');
  print('2. flutter run -d android');
  print('3. Testez la fonctionnalité de géolocalisation');
  
  print('\n📚 Consultez CONFIGURATION_API_KEYS.md pour plus de détails');
}

Future<void> updateApiConfig(String androidKey, String serverKey, String iosKey) async {
  final configFile = File('lib/config/api_config.dart');
  final content = await configFile.readAsString();
  
  final updatedContent = content
      .replaceAll('YOUR_GOOGLE_MAPS_API_KEY_HERE', androidKey)
      .replaceAll('YOUR_GOOGLE_PLACES_API_KEY_HERE', serverKey)
      .replaceAll('YOUR_GOOGLE_DIRECTIONS_API_KEY_HERE', serverKey);
  
  await configFile.writeAsString(updatedContent);
  print('✅ Fichier lib/config/api_config.dart mis à jour');
}

Future<void> updateAndroidManifest(String androidKey) async {
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  final content = await manifestFile.readAsString();
  
  final updatedContent = content.replaceAll('YOUR_GOOGLE_MAPS_API_KEY_HERE', androidKey);
  
  await manifestFile.writeAsString(updatedContent);
  print('✅ Fichier android/app/src/main/AndroidManifest.xml mis à jour');
}
