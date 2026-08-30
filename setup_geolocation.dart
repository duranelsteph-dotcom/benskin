#!/usr/bin/env dart

/// Script de configuration pour la fonctionnalité de géolocalisation
/// 
/// Ce script aide à configurer l'application avec les clés API nécessaires.
/// 
/// Usage: dart setup_geolocation.dart

import 'dart:io';

void main() {
  print('🗺️  Configuration de la fonctionnalité de géolocalisation');
  print('=' * 60);
  
  print('\n📋 Étapes de configuration :');
  print('1. Obtenez vos clés API Google depuis https://console.cloud.google.com/');
  print('2. Activez les APIs suivantes :');
  print('   • Maps SDK for Android');
  print('   • Maps SDK for iOS');
  print('   • Places API');
  print('   • Directions API');
  print('3. Créez des clés API avec les restrictions appropriées');
  
  print('\n🔧 Configuration des fichiers :');
  
  // Vérifier si les fichiers de configuration existent
  final configFile = File('lib/config/api_config.dart');
  if (configFile.existsSync()) {
    print('✅ Fichier de configuration trouvé : lib/config/api_config.dart');
    print('   ⚠️  N\'oubliez pas de remplacer les clés API par vos vraies clés !');
  } else {
    print('❌ Fichier de configuration manquant');
  }
  
  // Vérifier les permissions Android
  final androidManifest = File('android/app/src/main/AndroidManifest.xml');
  if (androidManifest.existsSync()) {
    final content = androidManifest.readAsStringSync();
    if (content.contains('ACCESS_FINE_LOCATION')) {
      print('✅ Permissions Android configurées');
    } else {
      print('❌ Permissions Android manquantes');
    }
  }
  
  // Vérifier les permissions iOS
  final iosInfoPlist = File('ios/Runner/Info.plist');
  if (iosInfoPlist.existsSync()) {
    final content = iosInfoPlist.readAsStringSync();
    if (content.contains('NSLocationWhenInUseUsageDescription')) {
      print('✅ Permissions iOS configurées');
    } else {
      print('❌ Permissions iOS manquantes');
    }
  }
  
  print('\n🚀 Commandes utiles :');
  print('• flutter pub get          - Installer les dépendances');
  print('• flutter run -d android   - Tester sur Android');
  print('• flutter run -d ios       - Tester sur iOS');
  print('• flutter run -d windows   - Tester sur Windows');
  
  print('\n📚 Documentation :');
  print('• Consultez GEOLOCATION_README.md pour plus de détails');
  print('• Exemple d\'utilisation dans lib/examples/maps_example.dart');
  
  print('\n✨ Configuration terminée !');
  print('N\'oubliez pas de configurer vos clés API avant de tester.');
}
