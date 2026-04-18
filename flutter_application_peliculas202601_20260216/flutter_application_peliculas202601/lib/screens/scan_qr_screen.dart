import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../models/qr_movie.dart';
import '../services/services.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  static const _accent = Color(0xFFE040FB);

  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_processing) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null) return;

    setState(() => _processing = true);
    await _controller.stop();

    try {
      final qr = QrMovie.fromJson(raw);

      final pos = await LocationService.getCurrentPosition();
      if (pos == null) {
        throw const LocationException(
            'No fue posible obtener tu ubicación actual.');
      }

      final now = DateTime.now();
      final scanDateTime =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final scan = QrScan(
        qr: qr,
        scanDateTime: scanDateTime,
        scanLat: pos.latitude,
        scanLng: pos.longitude,
      );

      if (!mounted) return;
      await context.read<QrStorageService>().addScan(scan);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, 'qrMap', arguments: scan);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR inválido o error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() => _processing = false);
      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, state, _) {
                final torchOn = state.torchState == TorchState.on;
                return Icon(
                  torchOn ? Icons.flash_on : Icons.flash_off,
                  color: torchOn ? Colors.amber : Colors.white,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetection,
            errorBuilder: (context, error, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Error de cámara: ${error.errorCode.name}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: _accent, width: 3),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          if (_processing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: _accent),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Alinea el QR dentro del recuadro',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
