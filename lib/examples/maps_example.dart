import 'package:flutter/material.dart';
import '../pages/maps_page.dart';

/// Exemple d'utilisation de la fonctionnalité de géolocalisation
/// 
/// Ce fichier montre comment intégrer la page de cartes dans votre application.
/// 
/// Pour utiliser cette fonctionnalité :
/// 1. Configurez vos clés API dans lib/config/api_config.dart
/// 2. Ajoutez les permissions nécessaires (déjà configurées)
/// 3. Naviguez vers la page MapsPage
class MapsExample extends StatelessWidget {
  const MapsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemple de Géolocalisation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Fonctionnalités de Géolocalisation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Cette application inclut :\n'
                '• Détection de position en temps réel\n'
                '• Suivi des déplacements\n'
                '• Recherche de destinations\n'
                '• Calcul d\'itinéraires\n'
                '• Affichage sur Google Maps',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MapsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text('Ouvrir la carte'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                _showConfigurationInfo(context);
              },
              icon: const Icon(Icons.info),
              label: const Text('Instructions de configuration'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigurationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuration requise'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pour utiliser cette fonctionnalité, vous devez :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('1. Obtenir des clés API Google :'),
              Text('   • Allez sur https://console.cloud.google.com/'),
              Text('   • Créez un projet ou sélectionnez un existant'),
              Text('   • Activez les APIs : Maps SDK, Places API, Directions API'),
              Text('   • Créez des clés API avec restrictions appropriées'),
              SizedBox(height: 12),
              Text('2. Configurer les clés :'),
              Text('   • Ouvrez lib/config/api_config.dart'),
              Text('   • Remplacez les clés par vos vraies clés'),
              SizedBox(height: 12),
              Text('3. Permissions :'),
              Text('   • Android : Configurées dans AndroidManifest.xml'),
              Text('   • iOS : Configurées dans Info.plist'),
              Text('   • Windows : Supporté via google_maps_flutter'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
