import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart';

import 'data.dart';
import 'utility.dart';

class FileUtil {
  static bool matchVersion(int v) {
    return fileVersion == v;
  }

  static Data load(String file, String password) {
    List<int> data = new File(file).readAsBytesSync();
    int my_ver = data.removeAt(0);
    if (matchVersion(my_ver)) {
      throw ("Unsupported password version");
    }
    List<int> decrypted = decrypt(data, password);
    String str = unzip(decrypted);
    return json.decode(str);
  }

  static void save(Data data, String filename, password) {
    String str = json.encode(data);
    List<int> zipped = zip(str);
    List<int> encrypted = encrypt(zipped, password);
    encrypted.add(fileVersion);
    new File(filename)
        .writeAsBytesSync(encrypted, mode: FileMode.write, flush: true);
  }

  static void saveFile(String str, String filename) {
    new File(filename).writeAsStringSync(str);
  }

  static List<int> encrypt(final List<int> data, String password) {
    final key = Key.fromUtf8(Util.paddingPassword(password));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encryptBytes(data, iv: iv);
    return encrypted.bytes;
  }

  static List<int> decrypt(List<int> data, String password) {
    final key = Key.fromUtf8(Util.paddingPassword(password));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = Encrypted(data);
    return encrypter.decryptBytes(encrypted, iv: iv);
  }

  static String unzip(List<int> data) {
    List<int> bytes = GZipDecoder().decodeBytes(data);
    return utf8.decode(bytes);
  }

  static List<int> zip(String text) {
    List<int> stringBytes = utf8.encode(text);
    return new GZipEncoder().encode(stringBytes);
  }
}
