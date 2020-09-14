import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'utility.dart';
import 'file_utility.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

class SecUtil {
  static RSAPublicKey publicKey;
  static RSAPrivateKey privateKey;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static Map<String, dynamic> deviceData;
  static final String signatureFileName = "SIGNATURE";
  static bool _validSignature = false;
  static bool get isValidSignature => _validSignature;

  static Future init() async {
    await _initKeys();
    await _initDeviceInfo();
    _validSignature = _checkSigature();
  }

  static Future _initKeys() async {
    try {
      String keyStr = await rootBundle.loadString("assets/public.pem");
      final parser = RSAKeyParser();
      publicKey = parser.parse(keyStr);
    } catch (e) {
      Log.error("Loading public key failed.", error: e);
    }
    /*
    try {
      String keyStr = await rootBundle.loadString("assets/private.pem");
      final parser = RSAKeyParser();
      privateKey = parser.parse(keyStr);
    } catch (e) {
      Log.error("Loading private key failed.", error: e);
    }
    */
  }

  static bool verify(String input, String signature) {
    final signer = Signer(RSASigner(RSASignDigest.SHA256,
        publicKey: publicKey, privateKey: privateKey));
    return signer.verify64(input.toUpperCase(), signature);
  }

  static Future _initDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch (e) {
      Log.error("Load device info failed.", error: e);
    }
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  static String getDeviceID() {
    if (deviceData == null) {
      return null;
    }
    if (Platform.isAndroid) {
      return deviceData['androidId'];
    } else if (Platform.isIOS) {
      return deviceData['identifierForVendor'];
    }
    return null;
  }

  static bool _checkSigature() {
    String path = Util.docDir.path + "/" + signatureFileName;
    if (!FileUtil.fileExist(path)) {
      return false;
    }
    try {
      String s = File(path).readAsStringSync().trim();
      String devId = getDeviceID();
      return verify(devId, s);
    } catch (e) {
      return false;
    }
  }
}
