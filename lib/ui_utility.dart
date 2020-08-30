import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/utility.dart';
import 'package:simple_password/theme/blue.dart';
import 'package:simple_password/theme/red.dart';
import 'package:simple_password/theme/dark.dart';
import 'package:simple_password/theme/teal.dart';
import 'package:simple_password/theme/indigo.dart';
import 'package:spinner_input/spinner_input.dart';

class UiUtil {
  static ThemeData currentTheme = blue;
  static String currentThemeName;
  static final biggerFont = const TextStyle(fontSize: 18.0);
  static final smallerFont = const TextStyle(fontSize: 12.0);
  static final edgeInsets = EdgeInsets.all(16.0);
  static final edgeInsets2 = EdgeInsets.only(left: 8.0, right: 8.0);

  static Text accessTime(DateTime d, {Color color}) {
    return readOnlyText(m.common.lastAccess, d, color: color);
  }

  static void alert(String title, String message, BuildContext context) async {
    await showOkAlertDialog(
        context: context,
        title: title,
        message: "\n" + message,
        alertStyle: AdaptiveStyle.material);
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
        backgroundColor: readOnly ? currentTheme.disabledColor : null,
        tooltip: m.common.confirm,
        child: new Icon(Icons.check_circle_outline),
        onPressed: readOnly ? null : () => _confirm(),
        heroTag: null,
      ),
    ]);
  }

  static Text createTime(DateTime d, {Color color}) {
    return readOnlyText(m.common.lastCreate, d, color: color);
  }

  static Text deltaTime(DateTime d, {Color color}) {
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
            color: currentTheme.disabledColor,
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
    if (color == null) {
      color = currentTheme.accentColor;
    }
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
    currentThemeName = theme;
    switch (theme) {
      case 'red':
        currentTheme = red;
        break;
      case 'dark':
        currentTheme = dark;
        break;
      case 'teal':
        currentTheme = teal;
        break;
      case 'indigo':
        currentTheme = indigo;
        break;
      case 'blue':
      default:
        currentTheme = blue;
    }
  }

  static Future initTheme() async {
    currentThemeName = Util.getTheme();
    _setTheme(currentThemeName);
  }

  static void setTheme(String theme) {
    if (theme == null || theme == '') {
      theme = Util.defaultTheme;
    }
    _setTheme(theme);
    Util.setTheme(theme);
  }

  static SpinnerButtonStyle _getPlusStyle(int type) {
    IconData icon = Icons.check;
    Color color = currentTheme.primaryColor;
    if (type == -1) {
      icon = Icons.remove;
    } else if (type == 1) {
      icon = Icons.add;
    } else if (type == 0) {
      color = currentTheme.cursorColor;
    }
    SpinnerButtonStyle _style = SpinnerButtonStyle();
    _style.child ??= Icon(icon, size: 16);
    _style.color ??= color;
    _style.textColor ??= currentTheme.buttonColor;
    _style.borderRadius ??= BorderRadius.circular(50);
    _style.width ??= 30;
    _style.height ??= 30;
    _style.elevation ??= null;
    _style.highlightColor ??= null;
    _style.highlightElevation ??= null;
    return _style;
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
          plusButton: _getPlusStyle(1),
          minusButton: _getPlusStyle(-1),
          popupButton: _getPlusStyle(0),
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
