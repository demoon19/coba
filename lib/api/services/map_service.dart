import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk GeoPoint

// Anda perlu mengimpor ini jika Anda benar-benar akan menampilkan peta interaktif
// import 'package:Maps_flutter/Maps_flutter.dart';

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

  double calculateDistance(GeoPoint start, GeoPoint end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    ); // Mengembalikan jarak dalam meter
  }

  // Jika Anda ingin menampilkan peta Google Map, Anda bisa menambahkan metode seperti ini
  // Future<GoogleMapController?> initializeMap(LatLng initialCameraPosition) async {
  //   // Ini adalah tempat untuk inisialisasi GoogleMapController
  //   // Namun, Anda perlu menambahkan widget GoogleMap di UI Anda
  //   // dan mengelola lifecycle controller-nya.
  //   return null; // Placeholder
  // }
}