import 'dart:convert';
import 'package:dart_des/dart_des.dart';

String encryptStringBSE(String toEncrypt) {
  var encryptedString = utf8.encode(toEncrypt);
  String key = "jm1[bsewebbapid202302151";
  var encryptedKey = utf8.encode(key);
  var tdes = DES3(
    key: encryptedKey,
    mode: DESMode.ECB,
    paddingType: DESPaddingType.PKCS7
  );

  var resultEncryption = tdes.encrypt(encryptedString);
  return base64.encode(resultEncryption).replaceAll('/', '@').replaceAll('+', '_');
}

String decryptStringBSE(String toDecrypt) {
  toDecrypt = toDecrypt.replaceAll('@', '/').replaceAll('_', '+');
  var byteArray = base64.decode(toDecrypt);
  String key = "jm1[bsewebbapid202302151";
  var encryptedKey = utf8.encode(key);
  var tdes = DES3(
    key: encryptedKey,
    mode: DESMode.ECB,
    paddingType: DESPaddingType.PKCS7
  );

  var resultStringArray = tdes.decrypt(byteArray);
  return utf8.decode(resultStringArray);
}