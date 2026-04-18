import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/qr_movie.dart';
import '../services/services.dart';

class QrMapScreen extends StatelessWidget {
  const QrMapScreen({super.key});

  static const _accent = Color(0xFFE040FB);

  @override
  Widget build(BuildContext context) {
    final QrScan scan = ModalRoute.of(context)!.settings.arguments as QrScan;
    final genLat = scan.qr.geoLat;
    final genLng = scan.qr.geoLng;

    if (genLat == null || genLng == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa de lectura')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'El QR no contiene coordenadas válidas.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    final genPoint = LatLng(genLat, genLng);
    final scanPoint = LatLng(scan.scanLat, scan.scanLng);

    final distanceMeters = LocationService.distanceMeters(
      genLat,
      genLng,
      scan.scanLat,
      scan.scanLng,
    );

    final midLat = (genLat + scan.scanLat) / 2;
    final midLng = (genLng + scan.scanLng) / 2;

    final bounds = LatLngBounds.fromPoints([genPoint, scanPoint]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lectura del QR'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(midLat, midLng),
                initialZoom: 10,
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.all(60),
                ),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.flutter_application_peliculas202601',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [genPoint, scanPoint],
                      color: _accent,
                      strokeWidth: 3,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: genPoint,
                      width: 50,
                      height: 50,
                      child: const _MapPin(
                        color: Colors.orangeAccent,
                        icon: Icons.qr_code_2_rounded,
                      ),
                    ),
                    Marker(
                      point: scanPoint,
                      width: 50,
                      height: 50,
                      child: const _MapPin(
                        color: _accent,
                        icon: Icons.camera_alt_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _DetailsPanel(scan: scan, distanceMeters: distanceMeters),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _MapPin({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  final QrScan scan;
  final double distanceMeters;
  const _DetailsPanel({required this.scan, required this.distanceMeters});

  String _formatDistance(double m) {
    if (m >= 1000) return '${(m / 1000).toStringAsFixed(2)} km';
    return '${m.toStringAsFixed(0)} m';
  }

  Future<void> _openRoute(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.openstreetmap.org/directions?engine=osrm_car'
      '&route=${scan.qr.geoLat},${scan.qr.geoLng};${scan.scanLat},${scan.scanLng}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la ruta.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.movie_filter_rounded,
                  color: Color(0xFFE040FB)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  scan.qr.originalTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _row(Icons.person_outline, 'Recomienda', scan.qr.nickname),
          _row(Icons.access_time_rounded, 'QR generado', scan.qr.fechaHora),
          _row(Icons.location_on_outlined, 'Geo generación',
              '${scan.qr.geoLat?.toStringAsFixed(5)}, ${scan.qr.geoLng?.toStringAsFixed(5)}'),
          _row(Icons.qr_code_scanner_rounded, 'QR leído',
              scan.scanDateTime),
          _row(Icons.my_location_rounded, 'Geo lectura',
              '${scan.scanLat.toStringAsFixed(5)}, ${scan.scanLng.toStringAsFixed(5)}'),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE040FB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.straighten_rounded,
                    color: Color(0xFFE040FB)),
                const SizedBox(width: 10),
                Text(
                  'Distancia: ${_formatDistance(distanceMeters)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openRoute(context),
              icon: const Icon(Icons.directions_rounded),
              label: const Text('Ver ruta entre los puntos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE040FB),
                side: const BorderSide(color: Color(0xFFE040FB)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.55)),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
