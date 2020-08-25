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

  static Future<bool> save(BuildContext context,
      {bool useBackupPolicy = true}) async {
    if (UiUtil.isReadOnly(context)) {
      return null;
    }
    bool yes =
        await UiUtil.confirm(m.common.confirm, m.common.saveAllAsk, context);
    String password = Util.decryptPassword(secPassword, data.key, randomIdx);
    if (yes) {
      if (FileUtil.backupAndSave(data.backupPolicy, currentFilename, data,
          password, useBackupPolicy)) {
        changes = 0;
        return true;
      } else {
        return false;
      }
    }
    return null;
  }
}
