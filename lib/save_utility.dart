import 'package:flutter/material.dart';
import 'package:simple_password/file_utility.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

class SaveUtil {
  static Future<bool> delete(BuildContext context, int i, List list) async {
    bool yes =
        await UiUtil.confirm(m.common.confirm, m.common.deleteThisAsk, context);
    if (yes) {
      list.removeAt(i);
      changes++;
      return true;
    }
    return false;
  }

  static bool load(String path, String secKey, BuildContext context) {
    String short = Util.getBasename(path);
    if (!FileUtil.fileExist(path)) {
      UiUtil.alert(
          m.file.fileNotFound, m.file.fileNotFoundErr("$short.sp"), context);
      return false;
    }
    try {
      data = FileUtil.load(path, secKey);
    } catch (e) {
      Log.error(m.file.openFailedErr("$short.sp"), error: e);
      UiUtil.alert(m.file.openErr,
          m.file.openFailedErr("$short.sp") + "\n${m.pswd.checkKey}", context);
      return false;
    }
    return true;
  }

  static Future<bool> discard(BuildContext context) async {
    if (UiUtil.isReadOnly(context)) {
      return null;
    }
    bool yes =
        await UiUtil.confirm(m.common.discard, m.common.discardMsg, context);
    if (yes) {
      String path = Util.getPath(currentFilename);
      String password = Util.decryptPassword(secPassword, data.key, randomIdx);
      if (load(path, password, context)) {
        changes = 0;
        Log.fine("Load file: $path, done");
        return true;
      } else {
        Log.warning("Load file $path, failed!");
      }
    }
    return false;
  }

  static Future<bool> save(BuildContext context,
      {bool useBackupPolicy = true, bool confirmed: false}) async {
    if (UiUtil.isReadOnly(context)) {
      return null;
    }
    bool yes = confirmed
        ? true
        : await UiUtil.confirm(m.common.confirm, m.common.saveAllAsk, context);
    if (yes) {
      String password = Util.decryptPassword(secPassword, data.key, randomIdx);
      String passwordNew;
      if (newSecPassword != null && newSecPassword != secPassword) {
        passwordNew = Util.decryptPassword(newSecPassword, data.key, randomIdx);
        secPassword = newSecPassword;
      }
      if (FileUtil.backupAndSave(data.backupPolicy, currentFilename, data,
          password, useBackupPolicy, passwordNew)) {
        changes = 0;
        return true;
      } else {
        return false;
      }
    }
    return null;
  }
}
