import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../errors/exceptions.dart'; // Import custom exceptions

class LocationUtils {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

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
  static double calculateDistance(GeoPoint start, GeoPoint end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
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
