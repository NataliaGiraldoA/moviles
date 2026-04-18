import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/qr_movie.dart';

class QrStorageService extends ChangeNotifier {
  static const _key = 'qr_scans_v1';

  List<QrScan> _scans = [];
  List<QrScan> get scans => List.unmodifiable(_scans);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _scans = raw
        .map((s) {
          try {
            return QrScan.fromJson(s);
          } catch (_) {
            return null;
          }
        })
        .whereType<QrScan>()
        .toList();
    notifyListeners();
  }

  Future<void> addScan(QrScan scan) async {
    _scans.insert(0, scan);
    await _persist();
    notifyListeners();
  }

  Future<void> removeAt(int index) async {
    if (index < 0 || index >= _scans.length) return;
    _scans.removeAt(index);
    await _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _scans.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      _scans.map((s) => json.encode(s.toMap())).toList(),
    );
  }
}
