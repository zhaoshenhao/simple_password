import 'package:flutter/material.dart';

import 'file_utility.dart';
import 'globals.dart';
import 'ui_utility.dart';
import 'utility.dart';

class SaveUtil {
  static Future<bool> delete(BuildContext context, int i, List list) async {
    bool yes = await UiUtil.confirm("Confirm", "Delete this item?", context);
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
    bool yes = await UiUtil.confirm("Confirm", "Save all changes?", context);
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
