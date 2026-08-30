import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class DirectionsRoute {
  final List<DirectionsLatLng> points;
  final String distance;
  final String duration;
  final String instructions;

  DirectionsRoute({
    required this.points,
    required this.distance,
    required this.duration,
    required this.instructions,
  });
}

class DirectionsLatLng {
  final double latitude;
  final double longitude;

  DirectionsLatLng({required this.latitude, required this.longitude});
}

class DirectionsService {
  static final DirectionsService _instance = DirectionsService._internal();
  factory DirectionsService() => _instance;
  DirectionsService._internal();

  /// Obtenir l'itinéraire entre deux points
  Future<DirectionsRoute?> getDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng, {
    String mode = 'driving', // driving, walking, bicycling, transit
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.directionsApiUrl}/json'
        '?origin=$startLat,$startLng'
        '&destination=$endLat,$endLng'
        '&mode=$mode'
        '&key=${ApiConfig.googleDirectionsApiKey}'
        '&language=fr'
        '&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0] as Map<String, dynamic>;
          final leg = route['legs'][0] as Map<String, dynamic>;
          
          // Extraire les points de la polyline
          final overviewPolyline = route['overview_polyline'] as Map<String, dynamic>;
          final polylinePoints = _decodePolyline(overviewPolyline['points'] as String);
          
          // Extraire les instructions
          final steps = leg['steps'] as List<dynamic>;
          final instructions = steps.map((step) {
            final htmlInstructions = step['html_instructions'] as String;
            return _stripHtmlTags(htmlInstructions);
          }).join('\n');

          return DirectionsRoute(
            points: polylinePoints,
            distance: leg['distance']['text'] as String,
            duration: leg['duration']['text'] as String,
            instructions: instructions,
          );
        } else {
          print('Aucun itinéraire trouvé: ${data['status']}');
          return null;
        }
      } else {
        print('Erreur API Directions: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de l\'obtention des directions: $e');
      return null;
    }
  }

  /// Décoder la polyline encodée de Google
  List<DirectionsLatLng> _decodePolyline(String polyline) {
    List<DirectionsLatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(DirectionsLatLng(
        latitude: lat / 1E5,
        longitude: lng / 1E5,
      ));
    }

    return points;
  }

  /// Supprimer les balises HTML des instructions
  String _stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}
