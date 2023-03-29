import 'package:encrypt/encrypt.dart' as encrypt;


final key = encrypt.Key.fromUtf8('K9vi9p1qymK0Ur4GdhXZXA==');
final iv = encrypt.IV.fromUtf8('J10M05F10I09N902');

String encryptString(String plainText) {
  final encrypter = encrypt.Encrypter(
  encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  var encrypted = encrypter.encrypt(plainText + currentTimeInSeconds(), iv: iv);
  return encrypted.base64;
}

String decryptString(String cipherText) {
  final encrypter = encrypt.Encrypter(
  encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  return encrypter.decrypt64(cipherText, iv: iv);
}

String currentTimeInSeconds() {
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  String str = ms.toString();
  str = str.substring(str.length - 3, str.length);
  return str;
}