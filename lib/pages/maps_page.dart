import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/places_service.dart';
import '../services/directions_service.dart';
import '../config/api_config.dart';
import 'maps_page_windows.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Détecter la plateforme et utiliser la version appropriée
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return const MapsPageWindows();
    } else {
      return const MapsPageMobile();
    }
  }
}

class MapsPageMobile extends StatefulWidget {
  const MapsPageMobile({super.key});

  @override
  State<MapsPageMobile> createState() => _MapsPageMobileState();
}

class _MapsPageMobileState extends State<MapsPageMobile> {
  final LocationService _locationService = LocationService();
  final PlacesService _placesService = PlacesService();
  final DirectionsService _directionsService = DirectionsService();
  
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Place> _searchResults = [];
  bool _isSearching = false;
  bool _isTracking = false;
  TextEditingController _searchController = TextEditingController();
  Place? _selectedDestination;
  DirectionsRoute? _currentRoute;

  // Position par défaut (Paris)
  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 12,
  );

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
      _updateMapToCurrentLocation();
    }

    // Écouter les changements de position
    _locationService.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
      _updateUserMarker();
    });
  }

  void _updateMapToCurrentLocation() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _updateUserMarker() {
    if (_currentPosition != null) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId.value == 'user_location');
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            infoWindow: const InfoWindow(
              title: 'Ma position',
              snippet: 'Position actuelle',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });
    }
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

    // Ajouter le marqueur de destination
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'destination');
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.formattedAddress,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
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
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: route.points.map((DirectionsLatLng point) => LatLng(point.latitude, point.longitude)).toList(),
              color: Colors.blue,
              width: 5,
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.location_on : Icons.location_off),
            onPressed: _toggleLocationTracking,
            tooltip: _isTracking ? 'Arrêter le suivi' : 'Démarrer le suivi',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _updateMapToCurrentLocation,
            tooltip: 'Ma position',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _defaultPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                _updateMapToCurrentLocation();
              }
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),
          
          // Barre de recherche
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final place = _searchResults[index];
                            return ListTile(
                              leading: const Icon(Icons.place),
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
            ),
          ),
          
          // Informations de position
          if (_currentPosition != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Position actuelle',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (_isTracking)
                        const Text(
                          'Suivi en cours...',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
