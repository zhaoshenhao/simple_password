import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/i18n/i18n.dart';

final int fileVersion = 0;

typedef void LocaleChangeCallback();

class Log {
  static error(String message, {var error}) =>
      dev.log("error: $message " + (error == null ? '' : error.toString()),
          name: "simple_password");
  static fine(String message, {var error}) =>
      dev.log("fine: $message " + (error == null ? '' : error.toString()),
          name: "simple_password");
  static severe(String message, {var error}) =>
      dev.log("severe: $message " + (error == null ? '' : error.toString()),
          name: "simple_password");
  static warning(String message, {var error}) =>
      dev.log("warning: $message " + (error == null ? '' : error.toString()),
          name: "simple_password");
}

class Util {
  static DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  static String ymdhms = "yyyyMMddHHmmss";
  static String ext = ".sp";
  static SharedPreferences sp;
  static Directory docDir;
  static Directory tmpDir;
  static final RegExp validCharacters = RegExp(r'^.*[a-zA-Z0-9\ ].*$');
  static final validCharacters2 = RegExp(r'^[a-zA-Z0-9_-]+$');
  static final String symboles = "~!@#\$£%^&*()_+-=[]{}|:;<>?,./";
  static final String lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  static final String upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static final String digits = "0123456789";
  static final String historyFilesKey = "HISTORY_FILES";
  static final String languageKey = "LANGUAGE";
  static final String paymentKey = "PAYMENT";
  static final String themeKey = 'THEME';
  static Locale locale = Locale('en', '');
  static LocaleChangeCallback localeChangeCallback;
  static final String defaultTheme = 'blue';

  static String dateTimeToString(DateTime d) {
    return formatter.format(d);
  }

  static String decryptPassword(String data, String keys, int idx) {
    if (data == null || data == '') {
      return data;
    }
    final key = Key.fromUtf8(getSecretKey(keys, idx));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = Encrypted.fromBase64(data);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  static String encryptPassword(final String text, String keys, int idx) {
    if (text == null || text == '') {
      return text;
    }
    final key = Key.fromUtf8(getSecretKey(keys, idx));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String generatePassword(int minUpperCase, int minLowerCase,
      int minDigit, int minSymbole, int length, String symChars) {
    String _special = '';
    if (minSymbole > 0) {
      if (symChars == null || symChars == '') {
        _special = Util.symboles;
      } else {
        _special = symChars;
      }
    }
    String allChars = "";

    //Put chars on the allowed ones based on the input values
    allChars += (minUpperCase > 0 ? lowerCaseLetters : '');
    allChars += (minLowerCase > 0 ? upperCaseLetters : '');
    allChars += (minDigit > 0 ? digits : '');
    allChars += (minSymbole > 0 ? _special : '');

    int i = 0;
    String _result = "";

    //Create password
    while (i < length.round()) {
      //Get random int
      int randomInt = Random.secure().nextInt(allChars.length);
      //Get random char and append it to the password
      _result += allChars[randomInt];
      i++;
    }

    return _result;
  }

  static String genPassword(PasswordPolicy passwordPolicy) {
    return generatePassword(
        passwordPolicy.minUpperCase,
        passwordPolicy.minLowerCase,
        passwordPolicy.minDigit,
        passwordPolicy.minSymbol,
        passwordPolicy.minLenght,
        passwordPolicy.allowedSymbols);
  }

  static String getBackupName(String bn) {
    return bn + "-" + Jiffy(DateTime.now()).format(ymdhms) + ext;
  }

  static String getBasename(String f) {
    return p.basenameWithoutExtension(f);
  }

  static List<String> getDeleteList(List<String> flist, BackupPolicy bp) {
    List<String> list = List();
    if (flist.length <= bp.totalBackups) {
      return list;
    }
    int delTotal = flist.length - bp.totalBackups;
    Jiffy now = Jiffy(DateTime.now());
    Jiffy preMonth = Jiffy(now.subtract(months: 1));
    Jiffy preWeek = Jiffy(now.subtract(days: 7));
    Jiffy preDay = Jiffy(now.subtract(days: 1));
    List<String> preMonthList = List();
    List<String> preWeekList = List();
    List<String> preDayList = List();
    List<String> badList = List();
    for (int i = 0; i < flist.length; i++) {
      String f = flist[i];
      String bn = p.basenameWithoutExtension(f);
      String tmStr = bn.substring(bn.length - 14, bn.length);
      String tmStr2 = tmStr.substring(0, 8) + "T" + tmStr.substring(8);
      DateTime dt;
      try {
        dt = DateTime.parse(tmStr2);
      } catch (e) {
        badList.add(flist[i]);
        continue;
      }
      Jiffy ft = Jiffy(dt);
      if (ft.year == preMonth.year && ft.month == preMonth.month) {
        preMonthList.add(f);
      }
      if (ft.year == preWeek.year && ft.week == preWeek.week) {
        preWeekList.add(f);
      }
      if (ft.year == preDay.year &&
          ft.month == preDay.month &&
          ft.day == preDay.day) {
        preDayList.add(f);
      }
    }
    list.addAll(badList);
    if (list.length >= delTotal) {
      return list;
    }
    if (preMonthList.isNotEmpty) {
      preMonthList.removeLast();
    }
    if (preWeekList.isNotEmpty) {
      preWeekList.removeLast();
    }
    if (preDayList.isNotEmpty) {
      preDayList.removeLast();
    }
    for (int i = 0; i < flist.length; i++) {
      String f = flist[i];
      if (list.length >= delTotal) {
        break;
      }
      if (!bp.keepLastMonth || !preMonthList.contains(f)) {
        list.add(f);
        continue;
      }
      if (!bp.keepLastWeek || !preWeekList.contains(f)) {
        list.add(f);
        continue;
      }
      if (!bp.keepOneDay || !preDayList.contains(f)) {
        list.add(f);
        continue;
      }
    }
    return list;
  }

  static List<String> getHistoryFiles() {
    List<String> hist = sp.getStringList(historyFilesKey);
    if (hist != null) {
      return hist.toSet().toList(growable: true);
    }
    return List();
  }

  static String getLanguage() {
    String lang = sp.getString(languageKey);
    if (lang == null || lang == '') {
      return 'en';
    }
    return lang;
  }

  static String getPayment() {
    return sp.getString(paymentKey);
  }

  static String getPath(String fn) {
    return Util.docDir.path + "/" + fn + ext;
  }

  static String getSecretKey(String keys, int idx) {
    return keys.substring(idx, idx + 32);
  }

  static String getTheme() {
    String theme = sp.getString(themeKey);
    if (theme == null || theme == '') {
      return defaultTheme;
    }
    return theme;
  }

  static String getTmpPath(String fn) {
    return Util.tmpDir.path + "/" + fn + ext;
  }

  static Future init() async {
    sp = await SharedPreferences.getInstance();
    docDir = await getApplicationDocumentsDirectory();
    tmpDir = await getTemporaryDirectory();
    String lang = getLanguage();
    if (lang == null || lang == '') {
      lang = 'en';
      setLanguage(lang);
    }
    locale = Locale(lang, '');
    loadMessage(locale.languageCode);
  }

  static bool isAlphaNum(String val) {
    return validCharacters.hasMatch(val);
  }

  static bool isInCurrentDir(String f) {
    String path = p.dirname(f);
    return (path == '.');
  }

  static bool isValidFileName(String val) {
    return validCharacters2.hasMatch(val);
  }

  static Data mockData() {
    Data d = new Data();
    d.basicData.name = "my_password";
    d.groups.add(mockGroup(d.key));
    return d;
  }

  static Group mockGroup(String key) {
    Group g = new Group();
    g.basicData.name = m.common.myGrpName;
    g.passwords.add(mockPassword(key));
    return g;
  }

  static Password mockPassword(String key) {
    Password p = new Password();
    p.basicData.name = m.common.mySecret;
    String tmp = randomString(8);
    p.key = Util.randomKey();
    p.password = encryptPassword(tmp, key, p.key);
    return p;
  }

  static String paddingPassword(String password) {
    double n = 32 / password.length + 1;
    String str = '';
    for (int i = 0; i < n.toInt(); i += 1) {
      str += password;
    }
    return str.substring(0, 0 + 32);
  }

  static int randomKey() {
    return new Random().nextInt(1000);
  }

  static String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });
    return new String.fromCharCodes(codeUnits);
  }

  static Future<bool> setHistoryFiles(List<String> filenames) {
    return sp.setStringList(historyFilesKey, filenames);
  }

  static Future<bool> setLanguage(String language) {
    loadMessage(language);
    return sp.setString(languageKey, language);
  }

  static Future<bool> setPayment(String payment) {
    return sp.setString(paymentKey, payment);
  }

  static Future<bool> setTheme(String theme) {
    return sp.setString(themeKey, theme);
  }
}
