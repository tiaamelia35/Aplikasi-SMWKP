import 'package:geolocator/geolocator.dart';

class MapsService {
  // Get current user location
  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Get address from coordinates (Geocoding)
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // TODO: Implement geocoding using google_maps_flutter or other service
      // For now, return a placeholder
      return '$latitude, $longitude';
    } catch (e) {
      throw Exception('Failed to get address: $e');
    }
  }

  // Get coordinates from address (Geocoding)
  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    try {
      // TODO: Implement geocoding using google_maps_flutter or other service
      // For now, return Palembang coordinates
      return {
        'latitude': -2.915808,
        'longitude': 104.745199,
      };
    } catch (e) {
      throw Exception('Failed to get coordinates: $e');
    }
  }

  // Open location in maps
  Future<void> openLocationInMaps(double latitude, double longitude) async {
    try {
      // TODO: Implement opening Google Maps or native maps app
      // This can be done using url_launcher package
    } catch (e) {
      throw Exception('Failed to open location in maps: $e');
    }
  }

  // Check if location is within area
  bool isLocationWithinArea(
    double lat,
    double lon,
    double centerLat,
    double centerLon,
    double radiusInMeters,
  ) {
    double distance = calculateDistance(centerLat, centerLon, lat, lon);
    return distance <= radiusInMeters;
  }
}
