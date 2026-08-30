#!/usr/bin/env dart

/// Script de configuration simple des clés API Google
/// 
/// Usage: dart configure_now.dart

import 'dart:io';

void main() async {
  print('🔑 Configuration des clés API Google');
  print('=====================================');
  
  print('\n📋 Instructions rapides :');
  print('1. Allez sur https://console.cloud.google.com/');
  print('2. Créez un projet');
  print('3. Activez : Maps SDK for Android, Places API, Directions API');
  print('4. Créez 2 clés API (Android + Serveur)');
  
  print('\n🔑 Entrez vos clés API :');
  
  stdout.write('Clé API Android: ');
  final androidKey = stdin.readLineSync()?.trim() ?? '';
  
  stdout.write('Clé API Serveur: ');
  final serverKey = stdin.readLineSync()?.trim() ?? '';
  
  if (androidKey.isEmpty || serverKey.isEmpty) {
    print('\n❌ Les clés sont obligatoires !');
    return;
  }
  
  print('\n🔧 Configuration en cours...');
  
  // Mettre à jour api_config.dart
  final configFile = File('lib/config/api_config.dart');
  if (configFile.existsSync()) {
    String content = await configFile.readAsString();
    content = content.replaceAll('YOUR_GOOGLE_MAPS_API_KEY_HERE', androidKey);
    content = content.replaceAll('YOUR_GOOGLE_PLACES_API_KEY_HERE', serverKey);
    content = content.replaceAll('YOUR_GOOGLE_DIRECTIONS_API_KEY_HERE', serverKey);
    await configFile.writeAsString(content);
    print('✅ lib/config/api_config.dart mis à jour');
  }
  
  // Mettre à jour AndroidManifest.xml
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (manifestFile.existsSync()) {
    String content = await manifestFile.readAsString();
    content = content.replaceAll('YOUR_GOOGLE_MAPS_API_KEY_HERE', androidKey);
    await manifestFile.writeAsString(content);
    print('✅ AndroidManifest.xml mis à jour');
  }
  
  print('\n✅ Configuration terminée !');
  print('\n🚀 Prochaines étapes :');
  print('1. flutter pub get');
  print('2. flutter run -d android');
  
  print('\nVoulez-vous exécuter "flutter pub get" maintenant ? (y/n)');
  final runFlutter = stdin.readLineSync()?.toLowerCase();
  
  if (runFlutter == 'y') {
    print('\n🔄 Exécution de flutter pub get...');
    final result = await Process.run('flutter', ['pub', 'get']);
    if (result.exitCode == 0) {
      print('✅ flutter pub get terminé !');
    } else {
      print('❌ Erreur: ${result.stderr}');
    }
  }
  
  print('\n🎉 Terminé ! Votre app est prête.');
}
