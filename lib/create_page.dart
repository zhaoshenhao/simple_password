import 'package:flutter/material.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/file_utility.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.create.createFile),
      ),
      body: new Center(
        child: new CreatePageWidget(),
      ),
    );
  }
}

class CreatePageWidget extends StatefulWidget {
  CreatePageWidget({Key key}) : super(key: key);

  @override
  _CreatePageWidgetState createState() => _CreatePageWidgetState();
}

class _CreatePageWidgetState extends State<CreatePageWidget> {
  final _formKey = GlobalKey<FormState>();
  Data _data;
  String _secKey1;
  String _secKey2;
  bool _showPassword1 = false;
  bool _showPassword2 = false;
  @override
  Widget build(BuildContext context) {
    _data = Util.mockData();
    BasicData _basicData = _data.basicData;
    return Form(
        key: _formKey,
        child: new ListView(padding: UiUtil.edgeInsets, children: <Widget>[
          TextFormField(
            cursorColor: UiUtil.currentTheme.accentColor,
            decoration: InputDecoration(
              labelText: m.create.fn,
              hintText: m.file.validFn,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return m.create.inputFn;
              }
              if (!Util.isValidFileName(value)) {
                return m.file.fnTips;
              }
              return null;
            },
            onChanged: (val) => {_basicData.name = val},
            initialValue: _basicData.name,
          ),
          TextFormField(
            cursorColor: UiUtil.currentTheme.accentColor,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: m.pswd.msKey,
                hintText: m.pswd.pswdHint,
                suffixIcon: GestureDetector(
                  onLongPressStart: (details) {
                    _showPassword1 = true;
                    setState(() {});
                  },
                  onLongPressEnd: (details) {
                    _showPassword1 = false;
                    setState(() {});
                  },
                  child: Icon(
                    _showPassword1 ? Icons.visibility : Icons.visibility_off,
                    color: UiUtil.currentTheme.accentColor,
                  ),
                )),
            obscureText: !_showPassword1,
            validator: (value) {
              if (value.isEmpty) {
                return m.pswd.pswdHint;
              }
              return null;
            },
            onChanged: (val) => {_secKey1 = val},
          ),
          TextFormField(
            cursorColor: UiUtil.currentTheme.accentColor,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: m.common.confirm,
                hintText: m.pswd.pswdHint,
                suffixIcon: GestureDetector(
                  onLongPressStart: (details) {
                    _showPassword2 = true;
                    setState(() {});
                  },
                  onLongPressEnd: (details) {
                    _showPassword2 = false;
                    setState(() {});
                  },
                  child: Icon(
                    _showPassword2 ? Icons.visibility : Icons.visibility_off,
                    color: UiUtil.currentTheme.accentColor,
                  ),
                )),
            obscureText: !_showPassword2,
            validator: (value) {
              if (value.isEmpty) {
                return m.pswd.pswdHint;
              }
              if (value != _secKey1) {
                return m.pswd.error;
              }
              return null;
            },
            onChanged: (val) => {_secKey2 = val},
          ),
          Text(''),
          Center(
              child: RaisedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _create(),
            label: Text(m.common.create),
            color: UiUtil.currentTheme.primaryColor,
            textColor: UiUtil.currentTheme.buttonColor,
          )),
        ]));
  }

  void _create() {
    if (_formKey.currentState.validate()) {
      String fn = Util.getPath(_data.basicData.name);
      if (FileUtil.fileExist(fn)) {
        UiUtil.alert(m.file.fileExists,
            m.file.fileExistErr(_data.basicData.name), context);
        return;
      }
      if (!FileUtil.save(_data, fn, _secKey2)) {
        UiUtil.alert(
            m.file.saveErrTitle, m.file.saveErr(_data.basicData.name), context);
        return;
      }
      List<String> hist = Util.getHistoryFiles();
      if (hist == null) {
        hist = List();
      }
      if (!hist.contains(_data.basicData.name)) {
        hist.insert(0, _data.basicData.name);
      }
      Util.setHistoryFiles(hist);
      Navigator.pop(context);
    }
  }
}
