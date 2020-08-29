import 'dart:convert';
import 'dart:io' show Platform;

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_password/utility.dart';
import 'package:simple_password/iap_utility.dart';

class AdmobUtil {
  static String unitId;

  static Future init() async {
    Log.fine("Release mode: " + kReleaseMode.toString());
    if (IapUtil.isPaid()) {
      Log.fine("Admob not in use");
      return;
    }
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return;
    }
    unitId = _getUnitId();
    Log.fine("unitId: " + unitId);
    if (unitId == null) {
      return;
    }
    List<String> testDevices = _getTestDevices();
    if (testDevices != null && testDevices.isNotEmpty) {
      Admob.initialize(testDeviceIds: testDevices);
    } else {
      Admob.initialize();
    }
  }

  static String _getUnitId() {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/6300978111';
    }
    if (Platform.isIOS) {
      return kReleaseMode
          ? 'ca-app-pub-3940256099942544/2934735716'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return null;
  }

  static List<String> _getTestDevices() {
    return List();
  }

  static Widget getBanner() {
    if (unitId == null || IapUtil.isPaid()) {
      return null;
    }
    return Container(
        child: AdmobBanner(
            adUnitId: unitId,
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              Log.fine("Event: " + event.toString());
              Log.fine("Args: " + jsonEncode(args));
              if (event == AdmobAdEvent.failedToLoad) {
                Log.warning("Failed to load admob banner");
              }
            }));
  }
}
