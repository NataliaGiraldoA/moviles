import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class QrHistoryScreen extends StatelessWidget {
  const QrHistoryScreen({super.key});

  static const _accent = Color(0xFFE040FB);

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<QrStorageService>();
    final scans = storage.scans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis lecturas de QR'),
        actions: [
          if (scans.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Borrar todas',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFF1A1A2E),
                    title: const Text('Borrar lecturas'),
                    content: const Text(
                        '¿Deseas eliminar todas las lecturas guardadas?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Borrar',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await storage.clear();
                }
              },
            ),
        ],
      ),
      body: scans.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: scans.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final scan = scans[i];
                final distance = (scan.qr.geoLat != null &&
                        scan.qr.geoLng != null)
                    ? LocationService.distanceMeters(
                        scan.qr.geoLat!,
                        scan.qr.geoLng!,
                        scan.scanLat,
                        scan.scanLng,
                      )
                    : null;
                return Dismissible(
                  key: ValueKey('${scan.qr.id}-${scan.scanDateTime}-$i'),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => storage.removeAt(i),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pushNamed(
                      context,
                      'qrMap',
                      arguments: scan,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_rounded,
                              color: _accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scan.qr.originalTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Recomendado por ${scan.qr.nickname}',
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Leído: ${scan.scanDateTime}',
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.45),
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'QR: ${scan.qr.fechaHora}',
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.45),
                                    fontSize: 11,
                                  ),
                                ),
                                if (distance != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      distance >= 1000
                                          ? 'Distancia: ${(distance / 1000).toStringAsFixed(2)} km'
                                          : 'Distancia: ${distance.toStringAsFixed(0)} m',
                                      style: const TextStyle(
                                        color: _accent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: Colors.white54),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              size: 70,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 14),
            Text(
              'Aún no has leído ningún QR.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
