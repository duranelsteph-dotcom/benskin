import 'package:flutter/material.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devenir conducteur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gagnez de l’argent en conduisant votre moto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Abonnement mensuel: 3 000 XAF'),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('• Réception de courses en priorité'),
                    SizedBox(height: 6),
                    Text('• Support dédié'),
                    SizedBox(height: 6),
                    Text('• Historique et revenus détaillés'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Abonnement'),
                    content: const Text('Paiement mensuel à venir (intégration OM/MM).'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.subscriptions_outlined),
              label: const Text('S’abonner'),
            )
          ],
        ),
      ),
    );
  }
}


