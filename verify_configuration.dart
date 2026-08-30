#!/usr/bin/env dart

/// Script de vérification de la configuration des clés API
/// 
/// Ce script vérifie que votre configuration est correcte.
/// 
/// Usage: dart verify_configuration.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔍 Vérification de la configuration des clés API');
  print('=' * 50);
  
  // Vérifier les fichiers de configuration
  await checkConfigurationFiles();
  
  // Vérifier les clés API
  await checkApiKeys();
  
  // Vérifier les permissions
  await checkPermissions();
  
  print('\n✅ Vérification terminée !');
}

Future<void> checkConfigurationFiles() async {
  print('\n📁 Vérification des fichiers de configuration...');
  
  final files = [
    'lib/config/api_config.dart',
    'android/app/src/main/AndroidManifest.xml',
    'ios/Runner/Info.plist',
    'pubspec.yaml',
  ];
  
  for (final filePath in files) {
    final file = File(filePath);
    if (file.existsSync()) {
      print('✅ $filePath');
    } else {
      print('❌ $filePath (manquant)');
    }
  }
}

Future<void> checkApiKeys() async {
  print('\n🔑 Vérification des clés API...');
  
  final configFile = File('lib/config/api_config.dart');
  if (!configFile.existsSync()) {
    print('❌ Fichier de configuration non trouvé');
    return;
  }
  
  final content = await configFile.readAsString();
  
  // Vérifier les clés
  final checks = [
    ('googleMapsApiKey', 'YOUR_GOOGLE_MAPS_API_KEY_HERE'),
    ('googlePlacesApiKey', 'YOUR_GOOGLE_PLACES_API_KEY_HERE'),
    ('googleDirectionsApiKey', 'YOUR_GOOGLE_DIRECTIONS_API_KEY_HERE'),
  ];
  
  for (final (keyName, placeholder) in checks) {
    if (content.contains(placeholder)) {
      print('⚠️  $keyName: Non configuré (utilise le placeholder)');
    } else if (content.contains('$keyName = \'\'')) {
      print('⚠️  $keyName: Vide');
    } else {
      print('✅ $keyName: Configuré');
    }
  }
  
  // Vérifier AndroidManifest.xml
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (manifestFile.existsSync()) {
    final manifestContent = await manifestFile.readAsString();
    if (manifestContent.contains('YOUR_GOOGLE_MAPS_API_KEY_HERE')) {
      print('⚠️  AndroidManifest.xml: Clé API non configurée');
    } else if (manifestContent.contains('com.google.android.geo.API_KEY')) {
      print('✅ AndroidManifest.xml: Clé API configurée');
    }
  }
}

Future<void> checkPermissions() async {
  print('\n🔐 Vérification des permissions...');
  
  // Vérifier Android
  final androidManifest = File('android/app/src/main/AndroidManifest.xml');
  if (androidManifest.existsSync()) {
    final content = await androidManifest.readAsString();
    final permissions = [
      'ACCESS_FINE_LOCATION',
      'ACCESS_COARSE_LOCATION',
      'ACCESS_BACKGROUND_LOCATION',
      'INTERNET',
    ];
    
    for (final permission in permissions) {
      if (content.contains(permission)) {
        print('✅ Android: $permission');
      } else {
        print('❌ Android: $permission (manquant)');
      }
    }
  }
  
  // Vérifier iOS
  final iosInfoPlist = File('ios/Runner/Info.plist');
  if (iosInfoPlist.existsSync()) {
    final content = await iosInfoPlist.readAsString();
    final permissions = [
      'NSLocationWhenInUseUsageDescription',
      'NSLocationAlwaysAndWhenInUseUsageDescription',
      'NSLocationAlwaysUsageDescription',
    ];
    
    for (final permission in permissions) {
      if (content.contains(permission)) {
        print('✅ iOS: $permission');
      } else {
        print('❌ iOS: $permission (manquant)');
      }
    }
  }
}

Future<void> testApiKey(String key, String apiName) async {
  if (key.isEmpty || key.contains('YOUR_') || key.contains('HERE')) {
    print('⚠️  $apiName: Clé non configurée');
    return;
  }
  
  try {
    // Test simple de la clé (exemple avec Places API)
    final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=test&key=$key';
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    
    if (response.statusCode == 200) {
      print('✅ $apiName: Clé valide');
    } else {
      print('❌ $apiName: Erreur ${response.statusCode}');
    }
  } catch (e) {
    print('⚠️  $apiName: Impossible de tester (${e.toString()})');
  }
}
