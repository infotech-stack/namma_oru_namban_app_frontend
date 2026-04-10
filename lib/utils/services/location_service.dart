// // lib/core/services/location_service.dart
//
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class LocationService {
//   // Current location எடு
//   static Future<Position?> getCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return null;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return null;
//     }
//     if (permission == LocationPermission.deniedForever) return null;
//
//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }
//
//   // Lat/Lng → Address convert பண்ணு
//   static Future<String> getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isEmpty) return '$lat, $lng';
//
//       final place = placemarks.first;
//       final parts = [
//         place.name,
//         place.street,
//         place.subLocality,
//         place.locality,
//         place.administrativeArea,
//       ].where((e) => e != null && e.isNotEmpty).toList();
//
//       return parts.take(3).join(', ');
//     } catch (e) {
//       return '$lat, $lng';
//     }
//   }
//
//   // Address → Lat/Lng convert பண்ணு
//   static Future<Location?> getLatLngFromAddress(String address) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isEmpty) return null;
//       return locations.first;
//     } catch (e) {
//       return null;
//     }
//   }
// }
// lib/features/address/data/services/location_service.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:userapp/core/logger/app_logger.dart';

class LocationResult {
  final double lat;
  final double lng;
  final String address;

  const LocationResult({
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class LocationService {
  // ── Check & request permission ────────────────────────────────
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.warning('LocationService: GPS service disabled');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppLogger.warning('LocationService: Permission denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppLogger.warning('LocationService: Permission permanently denied');
      return false;
    }

    return true;
  }

  // ── Check permission status ───────────────────────────────────
  Future<LocationPermission> getPermissionStatus() =>
      Geolocator.checkPermission();

  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    return await _reverseGeocode(lat, lng);
  }

  // ── Open app settings ─────────────────────────────────────────
  Future<void> openSettings() => Geolocator.openAppSettings();

  // ── Get current location ──────────────────────────────────────
  Future<LocationResult?> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      AppLogger.info(
        'LocationService: Got position — '
        '${position.latitude}, ${position.longitude}',
      );

      // Reverse geocode → address string
      final address = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      return LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );
    } catch (e) {
      AppLogger.error('LocationService: getCurrentLocation error=$e');
      return null;
    }
  }

  // ── Reverse geocode ───────────────────────────────────────────
  Future<String> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[
          if (p.subLocality?.isNotEmpty == true) p.subLocality!,
          if (p.locality?.isNotEmpty == true) p.locality!,
          if (p.administrativeArea?.isNotEmpty == true) p.administrativeArea!,
          if (p.country?.isNotEmpty == true) p.country!,
        ];
        return parts.join(', ');
      }
    } catch (e) {
      AppLogger.error('LocationService: reverseGeocode error=$e');
    }
    return '$lat, $lng';
  }

  // ── Forward geocode (address string → lat/lng) ────────────────
  Future<LocationResult?> geocodeAddress(String addressText) async {
    try {
      final locations = await locationFromAddress(addressText);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return LocationResult(
          lat: loc.latitude,
          lng: loc.longitude,
          address: addressText,
        );
      }
    } catch (e) {
      AppLogger.error('LocationService: geocodeAddress error=$e');
    }
    return null;
  }
}
