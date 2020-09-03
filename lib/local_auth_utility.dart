import 'dart:async';

class LocalAuthUtil {
  static bool canCheckBiometrics = false;
  static bool allowFingerPrint = false;
  static bool allowFace = false;
  static var error;

  static Future init() async {
    return;
  }

  static Future<int> check(String mesg) async {
    return 0;
  }

  static Future<bool> cancel() async {
    return true;
  }
}
