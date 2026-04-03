// lib/core/services/location_service.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Current location எடு
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Lat/Lng → Address convert பண்ணு
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return '$lat, $lng';

      final place = placemarks.first;
      final parts = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).toList();

      return parts.take(3).join(', ');
    } catch (e) {
      return '$lat, $lng';
    }
  }

  // Address → Lat/Lng convert பண்ணு
  static Future<Location?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) return null;
      return locations.first;
    } catch (e) {
      return null;
    }
  }
}
