import 'dart:convert';

class QrMovie {
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String geo;
  final String fechaHora;
  final String nickname;

  QrMovie({
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.geo,
    required this.fechaHora,
    required this.nickname,
  });

  double? get geoLat {
    final parts = geo.split(',');
    if (parts.length != 2) return null;
    return double.tryParse(parts[0].trim());
  }

  double? get geoLng {
    final parts = geo.split(',');
    if (parts.length != 2) return null;
    return double.tryParse(parts[1].trim());
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'geo': geo,
        'fechaHora': fechaHora,
        'nickname': nickname,
      };

  String toJson() => json.encode(toMap());

  factory QrMovie.fromMap(Map<String, dynamic> m) => QrMovie(
        id: m['id'] is int
            ? m['id'] as int
            : int.tryParse('${m['id']}') ?? 0,
        originalLanguage: (m['original_language'] ?? '').toString(),
        originalTitle: (m['original_title'] ?? '').toString(),
        geo: (m['geo'] ?? '').toString(),
        fechaHora: (m['fechaHora'] ?? '').toString(),
        nickname: (m['nickname'] ?? '').toString(),
      );

  factory QrMovie.fromJson(String src) =>
      QrMovie.fromMap(json.decode(src) as Map<String, dynamic>);
}

class QrScan {
  final QrMovie qr;
  final String scanDateTime;
  final double scanLat;
  final double scanLng;

  QrScan({
    required this.qr,
    required this.scanDateTime,
    required this.scanLat,
    required this.scanLng,
  });

  Map<String, dynamic> toMap() => {
        'qr': qr.toMap(),
        'scanDateTime': scanDateTime,
        'scanLat': scanLat,
        'scanLng': scanLng,
      };

  String toJson() => json.encode(toMap());

  factory QrScan.fromMap(Map<String, dynamic> m) => QrScan(
        qr: QrMovie.fromMap(Map<String, dynamic>.from(m['qr'] as Map)),
        scanDateTime: (m['scanDateTime'] ?? '').toString(),
        scanLat: (m['scanLat'] as num).toDouble(),
        scanLng: (m['scanLng'] as num).toDouble(),
      );

  factory QrScan.fromJson(String src) =>
      QrScan.fromMap(json.decode(src) as Map<String, dynamic>);
}
