import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showTraffic = true;
  bool _showRiderLocationToDriver = true;
  String _language = 'fr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Afficher embouteillages sur la carte'),
            value: _showTraffic,
            onChanged: (v) => setState(() => _showTraffic = v),
            secondary: const Icon(Icons.traffic_outlined),
          ),
          SwitchListTile(
            title: const Text('Montrer au conducteur où je me trouve'),
            value: _showRiderLocationToDriver,
            onChanged: (v) => setState(() => _showRiderLocationToDriver = v),
            secondary: const Icon(Icons.location_on_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Langue'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (v) => setState(() => _language = v ?? 'fr'),
            ),
          ),
        ],
      ),
    );
  }
}


