import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _notesKey = 'encrypted_notes';
  static const String _pinHashKey = 'pin_hash';
  static const String _themeKey = 'is_dark_mode';

  static Future<void> saveNotes(String encryptedJson) async {
    await _storage.write(key: _notesKey, value: encryptedJson);
  }

  static Future<String?> loadNotes() async {
    return _storage.read(key: _notesKey);
  }

  static Future<void> savePinHash(String hash) async {
    await _storage.write(key: _pinHashKey, value: hash);
  }

  static Future<String?> loadPinHash() async {
    return _storage.read(key: _pinHashKey);
  }

  static Future<void> saveThemeMode(bool isDark) async {
    await _storage.write(key: _themeKey, value: isDark.toString());
  }

  static Future<bool> loadThemeMode() async {
    final value = await _storage.read(key: _themeKey);
    return value == 'true';
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}