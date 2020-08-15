import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import 'globals.dart';
import 'utility.dart';

class UiUtil {
  static final biggerFont = const TextStyle(fontSize: 18.0);
  static final smallerFont = const TextStyle(fontSize: 12.0);
  static final edgeInsets = EdgeInsets.all(16.0);
  static final edgeInsets2 = EdgeInsets.only(left: 8.0, right: 8.0);

  static Text accessTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText("Last Access", d, color: color);
  }

  static Future<bool> confirm(
      String title, String msg, BuildContext context) async {
    final OkCancelResult result = await showOkCancelAlertDialog(
        context: context, title: title, message: "\n" + msg);
    if (result == OkCancelResult.ok) {
      return true;
    }
    return false;
  }

  static bool confirmAll(var context) {
    data.basicData.deltaTime = new DateTime.now();
    changes = changes + 1;
    Scaffold.of(context).showSnackBar(snackBar("Change confirmed"));
    return true;
  }

  static Widget confirmButton(var _confirm) {
    return new Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      new FloatingActionButton(
        backgroundColor: readOnly ? Colors.grey : Colors.red,
        tooltip: 'Confirm', // used by assistive technologies
        child: new Icon(Icons.check_circle_outline),
        onPressed: readOnly ? null : () => _confirm(),
        heroTag: null,
      ),
    ]);
  }

  static Text createTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText("Create Time", d, color: color);
  }

  static Text deltaTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText("Last Update", d, color: color);
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
      msg = "Read only mode.";
    }
    if (changes == 0) {
      msg = "No changes";
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
