import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final Key _key =
      Key.fromUtf8('my32lengthsupersecretkey1234567890');
  static final IV _iv = IV.fromLength(16);

  static String encrypt(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String cipherText) {
    final encrypter = Encrypter(AES(_key));
    return encrypter.decrypt(Encrypted.fromBase64(cipherText), iv: _iv);
  }
}