import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/models.dart';
import '../services/services.dart';

class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({super.key});

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  static const _accent = Color(0xFFE040FB);

  final _nicknameCtrl = TextEditingController();
  QrMovie? _qrData;
  bool _loadingLocation = false;
  String? _error;

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  Future<void> _buildQr(Movie movie) async {
    final nickname = _nicknameCtrl.text.trim();
    if (nickname.isEmpty) {
      setState(() => _error = 'Ingresa un nickname para continuar.');
      return;
    }

    setState(() {
      _loadingLocation = true;
      _error = null;
      _qrData = null;
    });

    try {
      final pos = await LocationService.getCurrentPosition();
      if (pos == null) {
        throw const LocationException('No fue posible obtener la ubicación.');
      }
      final now = DateTime.now();
      final fechaHora =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final qr = QrMovie(
        id: movie.id,
        originalLanguage: movie.originalLanguage,
        originalTitle: movie.originalTitle,
        geo: '${pos.latitude},${pos.longitude}',
        fechaHora: fechaHora,
        nickname: nickname,
      );
      if (!mounted) return;
      setState(() {
        _qrData = qr;
        _loadingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendar con QR'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MovieHeader(movie: movie),
              const SizedBox(height: 24),
              TextField(
                controller: _nicknameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tu nickname',
                  hintText: 'Natalia1711',
                  prefixIcon: const Icon(Icons.person_outline, color: _accent),
                  labelStyle: const TextStyle(color: _accent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: _accent.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _accent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed:
                    _loadingLocation ? null : () => _buildQr(movie),
                icon: _loadingLocation
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.qr_code_2_rounded),
                label: Text(
                  _loadingLocation ? 'Obteniendo ubicación…' : 'Generar QR',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ],
              if (_qrData != null) ...[
                const SizedBox(height: 28),
                _QrCard(qr: _qrData!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieHeader extends StatelessWidget {
  final Movie movie;
  const _MovieHeader({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 80,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${movie.id}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                'Idioma: ${movie.originalLanguage.toUpperCase()}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QrCard extends StatelessWidget {
  final QrMovie qr;
  const _QrCard({required this.qr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: qr.toJson(),
              version: QrVersions.auto,
              size: 240,
              gapless: true,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Película', value: qr.originalTitle),
          _InfoRow(label: 'ID', value: qr.id.toString()),
          _InfoRow(label: 'Idioma', value: qr.originalLanguage.toUpperCase()),
          _InfoRow(label: 'Geo', value: qr.geo),
          _InfoRow(label: 'Fecha y hora', value: qr.fechaHora),
          _InfoRow(label: 'Nickname', value: qr.nickname),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
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
