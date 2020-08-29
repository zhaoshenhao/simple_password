import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/utility.dart';
import 'package:spinner_input/spinner_input.dart';

class UiUtil {
  static Color priColor = Colors.blue;
  static Color disColor = Colors.grey;
  static String currentTheme;
  static final biggerFont = const TextStyle(fontSize: 18.0);
  static final smallerFont = const TextStyle(fontSize: 12.0);
  static final edgeInsets = EdgeInsets.all(16.0);
  static final edgeInsets2 = EdgeInsets.only(left: 8.0, right: 8.0);

  static Text accessTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText(m.common.lastAccess, d, color: color);
  }

  static Future<bool> confirm(
      String title, String msg, BuildContext context) async {
    final OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: title,
        message: "\n" + msg,
        alertStyle: AdaptiveStyle.material);
    if (result == OkCancelResult.ok) {
      return true;
    }
    return false;
  }

  static bool confirmAll(var context) {
    data.basicData.deltaTime = new DateTime.now();
    changes = changes + 1;
    Scaffold.of(context).showSnackBar(snackBar(m.common.chgConfirmed));
    return true;
  }

  static Widget confirmButton(var _confirm) {
    return new Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      new FloatingActionButton(
        backgroundColor: readOnly ? UiUtil.disColor : UiUtil.priColor,
        tooltip: m.common.confirm,
        child: new Icon(Icons.check_circle_outline),
        onPressed: readOnly ? null : () => _confirm(),
        heroTag: null,
      ),
    ]);
  }

  static Text createTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText(m.common.lastCreate, d, color: color);
  }

  static Text deltaTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText(m.common.lastDelta, d, color: color);
  }

  static Row headingRow(String text) {
    return Row(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Expanded(
          child: Container(
            height: 1.0,
            width: 130.0,
            color: Colors.black12,
          ),
        ),
      ],
    );
  }

  static bool isReadOnly(BuildContext context) {
    String msg;
    if (readOnly) {
      msg = m.sbs.roMode;
    }
    if (changes == 0) {
      msg = m.common.noChange;
    }
    if (msg != null) {
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(msg));
      return true;
    }
    return false;
  }

  static Text readOnlyText(String title, var value, {color: Colors.black45}) {
    return Text(
      title + ': ${Util.formatter.format(value)}',
      style: TextStyle(fontSize: 12, color: color),
    );
  }

  static snackBar(String text) {
    return new SnackBar(
      content: Text(text),
    );
  }

  static void _setTheme(theme) {
    currentTheme = theme;
    switch (theme) {
      case 'red':
        priColor = Colors.red;
        break;
      case 'black':
        priColor = Colors.black;
        break;
      case 'blue':
      default:
        priColor = Colors.blue;
    }
  }

  static Future initTheme() async {
    currentTheme = Util.getTheme();
    _setTheme(currentTheme);
  }

  static void setTheme(String theme) {
    if (theme == null || theme == '') {
      theme = Util.defaultTheme;
    }
    _setTheme(theme);
    Util.setTheme(theme);
  }

  static Row spinRow(
      String lable, double min, double max, double initValue, var setState) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(lable),
        ),
        Expanded(child: Container(color: Colors.amber)),
        SpinnerInput(
          spinnerValue: initValue,
          minValue: min,
          maxValue: max,
          onChange: (newValue) {
            setState(newValue);
          },
        ),
        Padding(
          padding: EdgeInsets.all(14.0),
        ),
      ],
    );
  }
}
