import 'package:flutter/material.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String _selected = 'cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modes de paiement')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioListTile<String>(
            value: 'cash',
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v ?? 'cash'),
            title: const Text('Espèces'),
            secondary: const Icon(Icons.payments_outlined),
          ),
          RadioListTile<String>(
            value: 'om',
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v ?? 'om'),
            title: const Text('Orange Money'),
            secondary: const Icon(Icons.phone_iphone),
          ),
          RadioListTile<String>(
            value: 'momo',
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v ?? 'momo'),
            title: const Text('Mobile Money'),
            secondary: const Icon(Icons.smartphone),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mode de paiement mis à jour')),
              );
            },
            child: const Text('Enregistrer'),
          )
        ],
      ),
    );
  }
}


