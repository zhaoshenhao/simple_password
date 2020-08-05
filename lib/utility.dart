import 'dart:convert' show json;
import 'dart:io' show File;
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data.dart';
import 'globals.dart';

class Log {
  static error(String message) => print("error: $message");
  static fine(String message) => print("fine: $message");
  static severe(String message) => print("severe: $message");
  static warning(String message) => print("warning: $message");
}

class Util {
  static DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
  static final RegExp validCharacters = RegExp(r'^.*[a-zA-Z0-9\ ].*$');
  static final String symboles = "~!@#\$£%^&*()_+-=[]{}|:;<>?,./";
  static String lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  static String upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static String digits = "0123456789";

  static String dateTimeToString(DateTime d) {
    return formatter.format(d);
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

  static String genPassword() {
    return generatePassword(
        data.passwordPolicy.minUpperCase,
        data.passwordPolicy.minLowerCase,
        data.passwordPolicy.minDigit,
        data.passwordPolicy.minSymbol,
        data.passwordPolicy.minLenght,
        data.passwordPolicy.allowedSymbols);
  }

  static bool isAlphaNum(String val) {
    return validCharacters.hasMatch(val);
  }

  static Data load(String file) {
    String str = new File(file).readAsStringSync();
    return json.decode(str);
  }

  static Data mockData() {
    Data data = new Data();
    data.basicData.name = "Test File";
    data.groups.add(mockGroup());
    data.groups.add(mockGroup());
    return data;
  }

  static Group mockGroup() {
    final wordPair = new WordPair.random();
    Group g = new Group();
    g.basicData.name = wordPair.asLowerCase;
    g.passwords.add(mockPassword());
    g.passwords.add(mockPassword());
    return g;
  }

  static Password mockPassword() {
    final wordPair = new WordPair.random();
    Password p = new Password();
    p.basicData.name = wordPair.asLowerCase;
    p.password = randomString(8);
    p.key = Util.randomKey();
    return p;
  }

  static int randomKey() {
    return new Random().nextInt(229);
  }

  static String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });
    return new String.fromCharCodes(codeUnits);
  }

  static void save(String str, String filename) {
    new File(filename).writeAsStringSync(str);
  }

  static void saveData(Data data, String filename) {
    String str = json.encode(data);
    new File(filename).writeAsStringSync(str);
  }
}
