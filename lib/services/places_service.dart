import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class Place {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String? photoReference;

  Place({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.photoReference,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final location = geometry['location'] as Map<String, dynamic>;
    
    return Place(
      placeId: json['place_id'] as String,
      name: json['name'] as String,
      formattedAddress: json['formatted_address'] as String,
      latitude: (location['lat'] as num).toDouble(),
      longitude: (location['lng'] as num).toDouble(),
      photoReference: json['photos'] != null && (json['photos'] as List).isNotEmpty
          ? (json['photos'][0] as Map<String, dynamic>)['photo_reference'] as String?
          : null,
    );
  }
}

class PlacesService {
  static final PlacesService _instance = PlacesService._internal();
  factory PlacesService() => _instance;
  PlacesService._internal();

  /// Rechercher des lieux avec autocomplete
  Future<List<Place>> searchPlaces(String query) async {
    try {
      if (query.isEmpty) return [];

      final url = Uri.parse(
        '${ApiConfig.placesApiUrl}/autocomplete/json'
        '?input=$query'
        '&key=${ApiConfig.googlePlacesApiKey}'
        '&types=establishment|geocode'
        '&language=fr'
        '&region=fr',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List<dynamic>;

        List<Place> places = [];
        for (var prediction in predictions) {
          final placeId = prediction['place_id'] as String;
          final placeDetails = await getPlaceDetails(placeId);
          if (placeDetails != null) {
            places.add(placeDetails);
          }
        }

        return places;
      } else {
        print('Erreur API Places: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la recherche de lieux: $e');
      return [];
    }
  }

  /// Obtenir les détails d'un lieu par son ID
  Future<Place?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.placesApiUrl}/details/json'
        '?place_id=$placeId'
        '&key=${ApiConfig.googlePlacesApiKey}'
        '&fields=place_id,name,formatted_address,geometry,photos'
        '&language=fr',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'] as Map<String, dynamic>;
        return Place.fromJson(result);
      } else {
        print('Erreur API Place Details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de l\'obtention des détails du lieu: $e');
      return null;
    }
  }

  /// Rechercher des lieux à proximité
  Future<List<Place>> searchNearbyPlaces(
    double latitude,
    double longitude,
    String type, {
    int radius = 1000,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.placesApiUrl}/nearbysearch/json'
        '?location=$latitude,$longitude'
        '&radius=$radius'
        '&type=$type'
        '&key=${ApiConfig.googlePlacesApiKey}'
        '&language=fr',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;

        return results.map((json) => Place.fromJson(json)).toList();
      } else {
        print('Erreur API Nearby Search: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la recherche de lieux à proximité: $e');
      return [];
    }
  }
}
