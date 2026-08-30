import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/places_service.dart';
import '../services/directions_service.dart';
import '../config/api_config.dart';

class MapsPageWindows extends StatefulWidget {
  const MapsPageWindows({super.key});

  @override
  State<MapsPageWindows> createState() => _MapsPageWindowsState();
}

class _MapsPageWindowsState extends State<MapsPageWindows> {
  final LocationService _locationService = LocationService();
  final PlacesService _placesService = PlacesService();
  final DirectionsService _directionsService = DirectionsService();
  
  Position? _currentPosition;
  List<Place> _searchResults = [];
  bool _isSearching = false;
  bool _isTracking = false;
  TextEditingController _searchController = TextEditingController();
  Place? _selectedDestination;
  DirectionsRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationService.stopLocationTracking();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    // Obtenir la position actuelle
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
    }

    // Écouter les changements de position
    _locationService.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _placesService.searchPlaces(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la recherche: $e')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _selectDestination(Place place) async {
    setState(() {
      _selectedDestination = place;
      _searchController.text = place.name;
      _searchResults = [];
    });

    // Calculer l'itinéraire si on a une position actuelle
    if (_currentPosition != null) {
      await _calculateRoute();
    }

    // Fermer le clavier
    FocusScope.of(context).unfocus();
  }

  Future<void> _calculateRoute() async {
    if (_currentPosition == null || _selectedDestination == null) return;

    try {
      final route = await _directionsService.getDirections(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _selectedDestination!.latitude,
        _selectedDestination!.longitude,
      );

      if (route != null) {
        setState(() {
          _currentRoute = route;
        });

        // Afficher les informations de l'itinéraire
        _showRouteInfo(route);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du calcul de l\'itinéraire: $e')),
      );
    }
  }

  void _showRouteInfo(DirectionsRoute route) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informations de l\'itinéraire'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distance: ${route.distance}'),
            const SizedBox(height: 8),
            Text('Durée: ${route.duration}'),
            const SizedBox(height: 8),
            const Text('Instructions:'),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                child: Text(route.instructions),
              ),
            ),
          ],
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

  void _toggleLocationTracking() {
    if (_isTracking) {
      _locationService.stopLocationTracking();
      setState(() {
        _isTracking = false;
      });
    } else {
      _locationService.startLocationTracking().then((success) {
        if (success) {
          setState(() {
            _isTracking = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de démarrer le suivi de position'),
            ),
          );
        }
      });
    }
  }

  void _openGoogleMaps() {
    if (_currentPosition != null && _selectedDestination != null) {
      final url = 'https://www.google.com/maps/dir/${_currentPosition!.latitude},${_currentPosition!.longitude}/${_selectedDestination!.latitude},${_selectedDestination!.longitude}';
      // Dans un vrai projet, vous utiliseriez url_launcher pour ouvrir le navigateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ouvrir dans Google Maps: $url'),
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord sélectionner une destination'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte (Windows)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.location_on : Icons.location_off),
            onPressed: _toggleLocationTracking,
            tooltip: _isTracking ? 'Arrêter le suivi' : 'Démarrer le suivi',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openGoogleMaps,
            tooltip: 'Ouvrir dans Google Maps',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une destination...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults = [];
                              });
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _searchPlaces,
                ),
                
                // Résultats de recherche
                if (_searchResults.isNotEmpty)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.place, color: Colors.blue),
                          title: Text(place.name),
                          subtitle: Text(place.formattedAddress),
                          onTap: () => _selectDestination(place),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          // Carte simulée
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Carte Google Maps',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version Windows - Carte simulée',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _openGoogleMaps,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Ouvrir dans Google Maps'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Google Maps Flutter ne supporte pas encore Windows.\nUtilisez le bouton ci-dessus pour ouvrir dans votre navigateur.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Informations de position
          if (_currentPosition != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Position actuelle',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                  Text(
                    'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                  if (_isTracking)
                    const Text(
                      'Suivi en cours...',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
