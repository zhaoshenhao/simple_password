import 'dart:async';
import 'dart:io' show Platform;

import 'package:local_auth/local_auth.dart';
import 'package:simple_password/utility.dart';

class LocalAuthUtil {
  static final LocalAuthentication auth = LocalAuthentication();
  static bool canCheckBiometrics;
  static List<BiometricType> availableBiometrics;
  static bool allowFingerPrint = false;
  static bool allowFace = false;
  static var error;

  static Future init() async {
    if (!Util.isMobile) {
      return;
    }
    canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return;
    }
    availableBiometrics = await auth.getAvailableBiometrics();
    if (Platform.isIOS) {
      allowFace = availableBiometrics.contains(BiometricType.face);
      allowFingerPrint =
          availableBiometrics.contains(BiometricType.fingerprint);
    } else if (Platform.isAndroid) {
      allowFingerPrint =
          availableBiometrics.contains(BiometricType.fingerprint);
    }
  }

  static Future<int> check(String mesg) async {
    try {
      bool ret = await auth.authenticateWithBiometrics(localizedReason: mesg);
      return ret ? 0 : 1;
    } catch (e) {
      Log.error("Local auth failed.", error: e);
      error = e;
      cancel();
      return -1;
    }
  }

  static Future<bool> cancel() async {
    try {
      return await auth.stopAuthentication();
    } catch (e) {
      Log.error("Local auth failed.", error: e);
      error = e;
      return false;
    }
  }
}
