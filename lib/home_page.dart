import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  int _currentIndex = 0;
  bool _isExpanded = true;
  bool _locationEnabled = true;
  DateTime? _scheduledAt;
  String _comfort = 'simple';

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _requestRide() {
    Navigator.of(context).pushNamed('/booking');
  }

  Future<void> _pickSchedule() async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: now,
    );
    if (date == null) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30))),
    );
    if (time == null) return;
    final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => _scheduledAt = scheduled);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Course programmée: ${scheduled.toString()}')),
    );
  }

  void _toggleLocation(bool value) {
    setState(() => _locationEnabled = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_locationEnabled ? 'Localisation activée' : 'Localisation désactivée')),
    );
  }

  Future<void> _shareLocation() async {
    const String mockUrl = 'https://benskin.app/share?lat=3.8480&lng=11.5021';
    await Clipboard.setData(const ClipboardData(text: mockUrl));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lien de position copié')),
    );
  }

  Widget _buildMapTab() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? 260 : 180,
              curve: Curves.easeInOut,
              color: Colors.green.shade50,
            ),
            SizedBox(
              height: _isExpanded ? 260 : 180,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Carte interactive',
                      style: TextStyle(color: Colors.green.shade800, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/maps');
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Ouvrir la carte'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'recenter',
                    onPressed: () {},
                    child: const Icon(Icons.my_location),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'layers',
                    onPressed: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                    child: const Icon(Icons.unfold_more),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _fromController,
                decoration: const InputDecoration(
                  labelText: 'Départ',
                  prefixIcon: Icon(Icons.my_location),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _toController,
                decoration: const InputDecoration(
                  labelText: 'Arrivée',
                  prefixIcon: Icon(Icons.place_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _requestRide,
                  icon: const Icon(Icons.motorcycle),
                  label: Text(
                    _comfort == 'vip' ? 'Demander une course (VIP)' : 'Demander une course',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'simple', label: Text('Simple'), icon: Icon(Icons.pedal_bike)),
                        ButtonSegment(value: 'vip', label: Text('VIP'), icon: Icon(Icons.umbrella)),
                      ],
                      selected: {_comfort},
                      onSelectionChanged: (s) => setState(() => _comfort = s.first),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickSchedule,
                      icon: const Icon(Icons.schedule),
                      label: Text(_scheduledAt == null ? 'Programmer' : 'Prévue: ${_scheduledAt!.hour.toString().padLeft(2, '0')}:${_scheduledAt!.minute.toString().padLeft(2, '0')}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.price_change_outlined),
                      label: const Text('Tarifs'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareLocation,
                      icon: const Icon(Icons.share_location_outlined),
                      label: const Text('Partager ma position'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Localisation'),
                          Switch(
                            value: _locationEnabled,
                            onChanged: _toggleLocation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text('Alerte SOS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text('Votre position et un message d\'urgence seront partagés.'),
                                const SizedBox(height: 12),
                                FilledButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('SOS déclenché (placeholder)')),
                                    );
                                  },
                                  icon: const Icon(Icons.sos),
                                  label: const Text('Déclencher SOS'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.sos),
                      label: const Text('SOS'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Inviter un conducteur'),
                            content: const Text('Partagez ce lien pour inviter un nouveau moto-taxi:\nhttps://benskin.app/invite'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Inviter un moto-taxi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text('Course #${index + 1}'),
          subtitle: const Text('Mvog-Ada → Mendong • 800 XAF'),
          trailing: const Text('Hier'),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: 5,
    );
  }

  Widget _buildProfileTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 28, child: Icon(Icons.person, size: 32)),
          const SizedBox(height: 12),
          const Text('Utilisateur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('+237 6xx xx xx'),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benskin'),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 28, child: Icon(Icons.person, size: 32)),
                    SizedBox(height: 8),
                    Text('Benskin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('+237 6xx xx xx'),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text('Paiements'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/payments');
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Historique des trajets'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history');
                },
              ),
              ListTile(
                leading: const Icon(Icons.motorcycle_outlined),
                title: const Text('Travailler comme conducteur'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/driver');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Paramètres'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMapTab(),
          _buildTripsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Carte'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}



