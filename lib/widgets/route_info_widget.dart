import 'package:flutter/material.dart';
import '../services/directions_service.dart';

class RouteInfoWidget extends StatelessWidget {
  final DirectionsRoute? route;
  final VoidCallback? onClearRoute;

  const RouteInfoWidget({
    super.key,
    this.route,
    this.onClearRoute,
  });

  @override
  Widget build(BuildContext context) {
    if (route == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informations de l\'itinéraire',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onClearRoute != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClearRoute,
                    tooltip: 'Effacer l\'itinéraire',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Distance et durée
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.straighten,
                    label: 'Distance',
                    value: route!.distance,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.access_time,
                    label: 'Durée',
                    value: route!.duration,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  route!.instructions,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
