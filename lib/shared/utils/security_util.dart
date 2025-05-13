import 'package:app/shared/constants/secrets.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

final class SecurityUtil {
  static final _key = encrypt.Key.fromUtf8(Secrets.chatEncryptKey);
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static String encryptPassword(String plainText) {
    return BCrypt.hashpw(plainText, BCrypt.gensalt());
  }

  static bool checkPW(String input, String password) {
    return BCrypt.checkpw(input, password);
  }

  static String encryptChat(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptChat(String encryptedChat) {
    final encrypted = encrypt.Encrypted.from64(encryptedChat);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}
