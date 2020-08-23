import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart';
import 'package:simple_password/globals.dart';

import 'data.dart';
import 'utility.dart';

class FileUtil {
  static void applyBackupPolicy(BackupPolicy bp, String bn) {
    List<String> list = listFile(bn);
    if (list.length <= bp.totalBackups) {
      return;
    }
    List<String> delList = Util.getDeleteList(list, bp);
    for (String fn in delList) {
      deleteFile(fn);
    }
    return;
  }

  static bool backup(String bn, Data data, String password) {
    String path = Util.docDir.path + "/" + Util.getBackupName(bn);
    return save(data, path, password);
  }

  static bool backupAndSave(BackupPolicy bp, String bn, Data data,
      String password, bool useBackupPolicy) {
    bool ret;
    if (bp.autoBackup && useBackupPolicy) {
      ret = backup(currentFilename, data, password);
      if (!ret) {
        return ret;
      }
    }
    String path = Util.docDir.path + "/" + currentFilename + Util.ext;
    ret = save(data, path, password);
    if (!ret) {
      return ret;
    }
    if (useBackupPolicy) {
      applyBackupPolicy(bp, currentFilename);
    }
    return true;
  }

  static List<int> decrypt(List<int> data, String password) {
    final key = Key.fromUtf8(Util.paddingPassword(password));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = Encrypted(data);
    return encrypter.decryptBytes(encrypted, iv: iv);
  }

  static void deleteFile(String fn) {
    File f;
    try {
      f = File(fn);
      if (f.existsSync()) {
        f.deleteSync();
      }
    } catch (e) {
      Log.error("Delete file ${f.path}failed", error: e);
    }
  }

  static void deleteFileInDocDir(String bfn) {
    String fn = Util.getPath(bfn);
    deleteFile(fn);
  }

  static List<int> encrypt(final List<int> data, String password) {
    final key = Key.fromUtf8(Util.paddingPassword(password));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encryptBytes(data, iv: iv);
    return encrypted.bytes;
  }

  static bool fileExist(String path) {
    return File(path).existsSync() || Directory(path).existsSync();
  }

  static String getValidCopyName(bn) {
    int cnt = 0;
    String nbn;
    String p;
    while (true) {
      if (cnt == 0) {
        nbn = bn;
      } else {
        nbn = bn + "_" + cnt.toString();
      }
      cnt++;
      p = Util.getPath(nbn);
      if (!new File(p).existsSync()) {
        return nbn;
      }
    }
  }

  static List<String> listFile(String bn) {
    List<FileSystemEntity> contents = Util.docDir.listSync();
    var p = RegExp(r"[0-9]{14}");
    List<String> list = List();
    for (FileSystemEntity f in contents) {
      if (f is File) {
        String fbn = Util.getBasename(f.path);
        if (p.hasMatch(fbn) && fbn.contains(bn)) {
          list.add(f.path);
        }
      }
    }
    list.sort((a, b) => a.compareTo(b));
    return list;
  }

  static List<String> listSpFiles() {
    List<FileSystemEntity> contents = Util.docDir.listSync();
    List<String> list = List();
    for (FileSystemEntity f in contents) {
      if (f is File) {
        String p = f.path;
        if (p.endsWith(Util.ext)) {
          list.add(Util.getBasename(p));
        }
      }
    }
    return list;
  }

  static Data load(String file, String password) {
    List<int> data = new File(file).readAsBytesSync();
    if (data == null || data.isEmpty) {
      return null;
    }
    int myVer = data[data.length - 1];
    List<int> data2 = data.sublist(0, data.length - 1);
    if (!matchVersion(myVer)) {
      throw ("Unsupported password version");
    }
    List<int> decrypted = decrypt(data2, password);
    String str = unzip(decrypted);
    return Data.fromJson(json.decode(str));
  }

  ///Make a copy to Doc dir.
  static String makeCopy(String p) {
    File f = new File(p);
    if (!f.existsSync()) {
      return null;
    }
    String bn = Util.getBasename(p);
    String nbn = getValidCopyName(bn);
    f.copySync(Util.getPath(nbn));
    return nbn;
  }

  static bool matchVersion(int v) {
    return fileVersion == v;
  }

  static bool save(Data data, String filename, String password) {
    String str = json.encode(data);
    List<int> zipped = zip(str);
    List<int> encrypted = encrypt(zipped, password);
    List<int> lv = new List(1);
    lv[0] = fileVersion;
    try {
      File file = new File(filename);
      file.writeAsBytesSync(encrypted, mode: FileMode.write, flush: true);
      file.writeAsBytesSync(lv, mode: FileMode.append, flush: true);
      return true;
    } catch (e) {
      Log.error("Save file failed", error: e);
      return false;
    }
  }

  static void saveFile(String str, String filename) {
    new File(filename).writeAsStringSync(str);
  }

  static String unzip(List<int> data) {
    List<int> bytes = GZipDecoder().decodeBytes(data);
    return utf8.decode(bytes);
  }

  static List<int> zip(String text) {
    List<int> stringBytes = utf8.encode(text);
    return new GZipEncoder().encode(stringBytes);
  }

  static bool copyToTmp(String p, String p2) {
    File f = new File(p);
    if (!f.existsSync()) {
      Log.error("File $p not exists");
      return false;
    }
    try {
      File fp2 = f.copySync(p2);
      if (fp2.existsSync()) {
        return true;
      }
      Log.error("Copy failed. Target file $p2 not found.");
      return false;
    } catch (e) {
      Log.error("Copy file to tmp dir failed.", error: e);
      return false;
    }
  }
}
