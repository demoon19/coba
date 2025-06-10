import 'package:geolocator/geolocator.dart';
import '../errors/exceptions.dart'; // Import custom exceptions

class LocationUtils {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw NoInternetException(
        'Location services are disabled. Please enable them.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw UnauthorizedException(
          'Location permissions are denied. Please allow location access for this app.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw UnauthorizedException(
        'Location permissions are permanently denied. Please enable them from app settings.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw FetchDataException('Failed to get current location: $e');
    }
  }

  /// Calculates the distance between two geographical points in meters.
  // Changed GeoPoint to Map<String, double> for local use
  static double calculateDistance(
    Map<String, double> start,
    Map<String, double> end,
  ) {
    if (!start.containsKey('latitude') ||
        !start.containsKey('longitude') ||
        !end.containsKey('latitude') ||
        !end.containsKey('longitude')) {
      throw ArgumentError(
        'Start and End maps must contain "latitude" and "longitude" keys.',
      );
    }

    return Geolocator.distanceBetween(
      start['latitude']!,
      start['longitude']!,
      end['latitude']!,
      end['longitude']!,
    );
  }

  /// Converts meters to kilometers.
  static String formatDistanceKm(double distanceMeters) {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} m';
    } else {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
  }
}
