import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamController<Position>? _positionController;
  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;

  /// Stream pour écouter les changements de position
  Stream<Position> get positionStream {
    _positionController ??= StreamController<Position>.broadcast();
    return _positionController!.stream;
  }

  /// Vérifier et demander les permissions de localisation
  Future<bool> requestLocationPermission() async {
    try {
      // Vérifier si la localisation est activée
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Les services de localisation sont désactivés.');
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission de localisation refusée.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission de localisation définitivement refusée. Veuillez l\'activer dans les paramètres.');
      }

      return true;
    } catch (e) {
      print('Erreur lors de la demande de permission: $e');
      return false;
    }
  }

  /// Obtenir la position actuelle
  Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Erreur lors de l\'obtention de la position: $e');
      return null;
    }
  }

  /// Démarrer le suivi de position en temps réel
  Future<bool> startLocationTracking() async {
    try {
      if (_isTracking) return true;

      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) return false;

      _positionController ??= StreamController<Position>.broadcast();

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Mettre à jour toutes les 10 mètres
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _positionController!.add(position);
        },
        onError: (error) {
          print('Erreur lors du suivi de position: $error');
        },
      );

      _isTracking = true;
      return true;
    } catch (e) {
      print('Erreur lors du démarrage du suivi: $e');
      return false;
    }
  }

  /// Arrêter le suivi de position
  void stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _isTracking = false;
  }

  /// Calculer la distance entre deux positions
  double calculateDistance(Position pos1, Position pos2) {
    return Geolocator.distanceBetween(
      pos1.latitude,
      pos1.longitude,
      pos2.latitude,
      pos2.longitude,
    );
  }

  /// Vérifier si le suivi est actif
  bool get isTracking => _isTracking;

  /// Nettoyer les ressources
  void dispose() {
    stopLocationTracking();
    _positionController?.close();
    _positionController = null;
  }
}
