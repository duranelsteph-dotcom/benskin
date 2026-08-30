import 'package:flutter/material.dart';

class ConsentPage extends StatefulWidget {
  const ConsentPage({super.key});

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _accepted = false;

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conditions d’utilisation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bienvenue sur Benskin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Avant de continuer, veuillez lire et accepter les Conditions de Benskin et la Politique de confidentialité.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => _showDialog(
                    'Conditions de Benskin',
                    'Texte des conditions d’utilisation (exemple).',
                  ),
                  child: const Text('Lire les conditions'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showDialog(
                    'Politique de confidentialité',
                    'Texte de la politique de confidentialité (exemple).',
                  ),
                  child: const Text('Politique de confidentialité'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _accepted,
              onChanged: (v) => setState(() => _accepted = v ?? false),
              title: const Text("J’accepte les conditions et la politique de confidentialité"),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _accepted
                  ? () => Navigator.of(context).pushReplacementNamed('/login')
                  : null,
              child: const Text('J’accepte et suivant'),
            ),
          ],
        ),
      ),
    );
  }
}


