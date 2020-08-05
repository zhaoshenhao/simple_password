import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import 'globals.dart';
import 'utility.dart';

class UiUtil {
  static final biggerFont = const TextStyle(fontSize: 18.0);
  static final smallerFont = const TextStyle(fontSize: 12.0);

  static Text accessTime(DateTime d, {color: Colors.black45}) {
    return readOnlyText("Last Access", d, color: color);
  }

  static bool confirmAll(var context) {
    data.basicData.deltaTime = new DateTime.now();
    changes = changes + 1;
    Scaffold.of(context).showSnackBar(snackBar("Change confirmed"));
    return true;
  }

  static Widget confirmButton(var _confirm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: new Center(
          child: new RaisedButton(
        onPressed: () => _confirm(),
        color: Colors.red,
        textColor: Colors.white,
        child: Text('Confirm'),
      )),
    );
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
