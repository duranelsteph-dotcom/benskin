import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des trajets')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.motorcycle),
            title: Text('Course #${index + 1} • 800 XAF'),
            subtitle: const Text('Biyem-Assi → Nsam • 12 min'),
            trailing: const Text('12/08 14:20'),
            onTap: () {},
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: 10,
      ),
    );
  }
}


