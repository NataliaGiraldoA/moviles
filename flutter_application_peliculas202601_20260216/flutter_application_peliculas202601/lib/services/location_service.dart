import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
          'El servicio de ubicación está desactivado. Actívalo para continuar.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException(
            'Se requiere permiso de ubicación para continuar.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
          'El permiso de ubicación fue denegado permanentemente. Habilítalo desde los ajustes.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
  @override
  String toString() => message;
}
