import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthUtil {
  static final LocalAuthentication auth = LocalAuthentication();
  static bool canCheckBiometrics;
  static List<BiometricType> availableBiometrics;
  static bool allowFingerPrint = false;
  static bool allowFace = false;

  static Future init() async {
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
}
