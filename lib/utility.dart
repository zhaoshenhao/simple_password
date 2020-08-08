import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

final int fileVersion = 0;
final String version = "0.0.1";

class Log {
  static error(String message, {var error}) =>
      dev.log("error: $message" + error == null ? '' : jsonEncode(error));
  static fine(String message, {var error}) =>
      dev.log("fine: $message" + error == null ? '' : jsonEncode(error));
  static severe(String message, {var error}) =>
      dev.log("severe: $message" + error == null ? '' : jsonEncode(error));
  static warning(String message, {var error}) =>
      dev.log("warning: $message" + error == null ? '' : jsonEncode(error));
}

class Util {
  static DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
  static SharedPreferences sp;
  static final RegExp validCharacters = RegExp(r'^.*[a-zA-Z0-9\ ].*$');
  static final String symboles = "~!@#\$£%^&*()_+-=[]{}|:;<>?,./";
  static final String lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  static final String upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static final String digits = "0123456789";
  static final String historyFilesKey = "HISTORY_FILES";
  static final String languageKey = "LANGUAGE";

  static List<String> checkPassword(
      String password, PasswordPolicy passwordPolicy) {
    List<String> list = List();
    if (password == null || password == '') {
      list.add("Password is empty");
      return list;
    }
    if (password.length < passwordPolicy.minLenght) {
      list.add("Length < " + passwordPolicy.minLenght.toString());
    }
    int lower = 0;
    int upper = 0;
    int digit = 0;
    int special = 0;
    for (int i = 0; i < password.length; i++) {
      int m = password.codeUnitAt(i);
      if (48 <= m && m <= 57)
        digit += 1;
      else if (65 <= 65 && m <= 90)
        upper += 1;
      else if (97 <= m && m <= 112)
        lower += 1;
      else
        special += 1;
    }
    if (lower < passwordPolicy.minLowerCase) {
      list.add("Must contain " +
          passwordPolicy.minLowerCase.toString() +
          " lower case letters");
    }
    if (upper < passwordPolicy.minUpperCase) {
      list.add("Must contain " +
          passwordPolicy.minUpperCase.toString() +
          " uppers case letters");
    }
    if (digit < passwordPolicy.minDigit) {
      list.add(
          "Must contain " + passwordPolicy.minDigit.toString() + " digits");
    }
    if (special < passwordPolicy.minSymbol) {
      list.add("Must contain " +
          passwordPolicy.minSymbol.toString() +
          " special chars");
    }
    return list;
  }

  static String dateTimeToString(DateTime d) {
    return formatter.format(d);
  }

  static String decryptPassword(String data, String keys, int idx) {
    final key = Key.fromUtf8(getSecretKey(keys, idx));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = Encrypted.fromBase64(data);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  static String encryptPassword(final String text, String keys, int idx) {
    final key = Key.fromUtf8(getSecretKey(keys, idx));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String generatePassword(int minUpperCase, int minLowerCase,
      int minDigit, int minSymbole, int length, String symChars) {
    //Define the allowed chars to use in the password
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

  static List<String> getHistoryFiles() {
    return sp.getStringList(historyFilesKey);
  }

  static String getLanguage() {
    String lang = sp.getString(languageKey);
    if (lang == null || lang == '') {
      return 'en_US';
    }
    return lang;
  }

  static String getSecretKey(String keys, int idx) {
    return keys.substring(idx, idx + 32);
  }

  static Future init() async {
    sp = await SharedPreferences.getInstance();
  }

  static bool isAlphaNum(String val) {
    return validCharacters.hasMatch(val);
  }

  static Data mockData() {
    Data d = new Data();
    d.basicData.name = "my_password";
    d.groups.add(mockGroup(d.key));
    return d;
  }

  static Group mockGroup(String keys) {
    Group g = new Group();
    g.basicData.name = "my password group";
    g.passwords.add(mockPassword(keys));
    return g;
  }

  static Password mockPassword(String keys) {
    Password p = new Password();
    p.basicData.name = "my secret";
    String tmp = randomString(8);
    p.key = Util.randomKey();
    p.password = encryptPassword(tmp, keys, p.key);
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
    return sp.setString(languageKey, language);
  }
}
