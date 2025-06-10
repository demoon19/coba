import 'package:geolocator/geolocator.dart';

// No need for cloud_firestore import anymore
// import 'package:cloud_firestore/cloud_firestore.dart'; // Removed

// If you plan to use a local map library, you might import it here.
// For example:
// import 'package:latlong2/latlong.dart'; // A popular package for geospatial calculations

class MapService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Changed GeoPoint to Map<String, double>
  double calculateDistance(Map<String, double> start, Map<String, double> end) {
    if (!start.containsKey('latitude') || !start.containsKey('longitude') ||
        !end.containsKey('latitude') || !end.containsKey('longitude')) {
      throw ArgumentError('Start and End maps must contain "latitude" and "longitude" keys.');
    }

    return Geolocator.distanceBetween(
      start['latitude']!,
      start['longitude']!,
      end['latitude']!,
      end['longitude']!,
    ); // Returns distance in meters
  }

  // If you want to display a local map, you might add a method like this
  // and import a local map widget library (e.g., flutter_map, Maps_flutter if not using Firebase)
  // Future<dynamic?> initializeMap(Map<String, double> initialCameraPosition) async {
  //   // This is where you would initialize a map controller for your chosen map library.
  //   // You would also need to add the map widget to your UI.
  //   // For example, if using Maps_flutter without Firebase, you'd manage its controller.
  //   return null; // Placeholder
  // }
}