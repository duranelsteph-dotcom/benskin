#!/usr/bin/env dart

/// Script de configuration automatique des clés API Google
/// 
/// Ce script vous guide étape par étape pour configurer vos clés API.
/// 
/// Usage: dart auto_configure.dart

import 'dart:io';

void main() async {
  print('🔑 Configuration automatique des clés API Google');
  print('=' * 50);
  
  // Vérifier si les fichiers existent
  final configFile = File('lib/config/api_config.dart');
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  
  if (!configFile.existsSync()) {
    print('❌ Fichier de configuration non trouvé: lib/config/api_config.dart');
    return;
  }
  
  if (!manifestFile.existsSync()) {
    print('❌ Fichier AndroidManifest.xml non trouvé');
    return;
  }
  
  print('\n📋 Instructions de configuration :');
  print('1. Allez sur https://console.cloud.google.com/');
  print('2. Créez un projet ou sélectionnez un existant');
  print('3. Activez ces APIs :');
  print('   • Maps SDK for Android');
  print('   • Maps SDK for iOS');
  print('   • Places API');
  print('   • Directions API');
  print('4. Créez 2 clés API :');
  print('   • Clé Android (restreinte aux apps Android)');
  print('   • Clé Serveur (pour Places API et Directions API)');
  
  print('\n🌐 Ouverture de Google Cloud Console...');
  
  // Ouvrir Google Cloud Console
  if (Platform.isWindows) {
    Process.run('start', ['https://console.cloud.google.com/']);
  } else if (Platform.isMacOS) {
    Process.run('open', ['https://console.cloud.google.com/']);
  } else if (Platform.isLinux) {
    Process.run('xdg-open', ['https://console.cloud.google.com/']);
  }
  
  print('\n⏳ Appuyez sur Entrée quand vous avez terminé la configuration sur Google Cloud...');
  stdin.readLineSync();
  
  print('\n🔑 Saisissez vos clés API :');
  
  stdout.write('Clé API Android: ');
  final androidKey = stdin.readLineSync()?.trim() ?? '';
  
  stdout.write('Clé API Serveur (Places/Directions): ');
  final serverKey = stdin.readLineSync()?.trim() ?? '';
  
  if (androidKey.isEmpty || serverKey.isEmpty) {
    print('\n❌ Les clés API sont obligatoires !');
    return;
  }
  
  print('\n🔧 Configuration de l\'application...');
  
  // Mettre à jour api_config.dart
  print('📝 Mise à jour de lib/config/api_config.dart...');
  await updateApiConfig(androidKey, serverKey);
  
  // Mettre à jour AndroidManifest.xml
  print('📝 Mise à jour de android/app/src/main/AndroidManifest.xml...');
  await updateAndroidManifest(androidKey);
  
  print('\n✅ Configuration terminée !');
  print('\n🚀 Prochaines étapes :');
  print('1. flutter pub get');
  print('2. flutter run -d android');
  print('3. Testez la fonctionnalité de géolocalisation');
  
  // Proposer d'exécuter flutter pub get
  print('\n🔄 Voulez-vous exécuter \'flutter pub get\' maintenant ? (y/n)');
  final runFlutter = stdin.readLineSync()?.toLowerCase();
  
  if (runFlutter == 'y' || runFlutter == 'yes') {
    print('\n🔄 Exécution de flutter pub get...');
    final result = await Process.run('flutter', ['pub', 'get']);
    
    if (result.exitCode == 0) {
      print('✅ flutter pub get terminé avec succès !');
    } else {
      print('❌ Erreur lors de l\'exécution de flutter pub get');
      print('Erreur: ${result.stderr}');
    }
  }
  
  print('\n🎉 Configuration terminée ! Votre application est prête.');
  print('📚 Consultez GEOLOCATION_README.md pour plus de détails');
}

Future<void> updateApiConfig(String androidKey, String serverKey) async {
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
