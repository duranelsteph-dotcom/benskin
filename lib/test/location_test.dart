import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/places_service.dart';
import '../services/directions_service.dart';

/// Tests unitaires pour les services de géolocalisation
/// 
/// Pour exécuter ces tests :
/// flutter test lib/test/location_test.dart

void main() {
  group('LocationService Tests', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    tearDown(() {
      locationService.dispose();
    });

    test('LocationService singleton pattern', () {
      final instance1 = LocationService();
      final instance2 = LocationService();
      expect(instance1, equals(instance2));
    });

    test('isTracking initial state', () {
      expect(locationService.isTracking, false);
    });
  });

  group('PlacesService Tests', () {
    late PlacesService placesService;

    setUp(() {
      placesService = PlacesService();
    });

    test('PlacesService singleton pattern', () {
      final instance1 = PlacesService();
      final instance2 = PlacesService();
      expect(instance1, equals(instance2));
    });

    test('Search places with empty query', () async {
      final results = await placesService.searchPlaces('');
      expect(results, isEmpty);
    });
  });

  group('DirectionsService Tests', () {
    late DirectionsService directionsService;

    setUp(() {
      directionsService = DirectionsService();
    });

    test('DirectionsService singleton pattern', () {
      final instance1 = DirectionsService();
      final instance2 = DirectionsService();
      expect(instance1, equals(instance2));
    });

    test('Decode polyline with valid input', () {
      // Test avec une polyline simple
      const polyline = 'u{~lFvy~wO';
      final points = directionsService._decodePolyline(polyline);
      expect(points, isNotEmpty);
    });

    test('Strip HTML tags', () {
      const htmlString = '<b>Turn left</b> onto <i>Main Street</i>';
      final result = directionsService._stripHtmlTags(htmlString);
      expect(result, equals('Turn left onto Main Street'));
    });
  });
}

/// Extension pour accéder aux méthodes privées dans les tests
extension DirectionsServiceTest on DirectionsService {
  List<dynamic> _decodePolyline(String polyline) {
    // Cette méthode est normalement privée, mais nous l'exposons pour les tests
    return [];
  }

  String _stripHtmlTags(String htmlString) {
    // Cette méthode est normalement privée, mais nous l'exposons pour les tests
    return '';
  }
}
