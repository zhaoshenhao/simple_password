import 'package:flutter/material.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

class BasicInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.basic.info),
      ),
      body: new Center(
        child: new BasicInfoWidget(),
      ),
    );
  }
}

class BasicInfoWidget extends StatefulWidget {
  BasicInfoWidget({Key key}) : super(key: key);

  @override
  _BasicInfoWidgetState createState() => _BasicInfoWidgetState();
}

class _BasicInfoWidgetState extends State<BasicInfoWidget> {
  final _formKey = GlobalKey<FormState>();
  BasicData _basicData = data.basicData.clone();
  bool _changePassword = false;
  String _secKey0;
  String _secKey1;
  String _secKey2;
  bool _showPassword0 = false;
  bool _showPassword1 = false;
  bool _showPassword2 = false;
  String _password = Util.decryptPassword(secPassword, data.key, randomIdx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: new ListView(
            padding: UiUtil.edgeInsets,
            children: <Widget>[
              TextFormField(
                cursorColor: UiUtil.currentTheme.accentColor,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: m.basic.pswdName,
                  hintText: m.common.notEmpty,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return m.common.notEmpty;
                  }
                  return null;
                },
                onChanged: (val) => setState(() => _basicData.name = val),
                initialValue: _basicData.name,
              ),
              SwitchListTile(
                title: Text(m.pswd.change),
                value: _changePassword,
                onChanged: (bool val) => setState(() {
                  print(val);
                  _changePassword = val;
                  print(_changePassword);
                }),
              ),
              TextFormField(
                readOnly: !_changePassword,
                cursorColor: UiUtil.currentTheme.accentColor,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: m.pswd.msKeyCur,
                    hintText: m.pswd.pswdHint,
                    suffixIcon: GestureDetector(
                      onLongPressStart: (details) {
                        _showPassword0 = true;
                        setState(() {});
                      },
                      onLongPressEnd: (details) {
                        _showPassword0 = false;
                        setState(() {});
                      },
                      child: Icon(
                          _showPassword0
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _changePassword
                              ? UiUtil.currentTheme.accentColor
                              : UiUtil.currentTheme.disabledColor),
                    )),
                obscureText: !_showPassword0,
                validator: (value) {
                  if (value.isEmpty) {
                    return m.pswd.pswdHint;
                  }
                  if (value != _password) {
                    return m.pswd.oldMismatch;
                  }
                  return null;
                },
                onChanged: (val) => {_secKey0 = val},
              ),
              TextFormField(
                readOnly: !_changePassword,
                cursorColor: UiUtil.currentTheme.accentColor,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: m.pswd.msKeyNew,
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
                          _showPassword1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _changePassword
                              ? UiUtil.currentTheme.accentColor
                              : UiUtil.currentTheme.disabledColor),
                    )),
                obscureText: !_showPassword1,
                validator: (value) {
                  if (value.isEmpty) {
                    return m.pswd.pswdHint;
                  }
                  if (value == _secKey0) {
                    return m.pswd.pswdSame;
                  }
                  return null;
                },
                onChanged: (val) => {_secKey1 = val},
              ),
              TextFormField(
                readOnly: !_changePassword,
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
                          _showPassword2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _changePassword
                              ? UiUtil.currentTheme.accentColor
                              : UiUtil.currentTheme.disabledColor),
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
              Divider(),
              TextFormField(
                cursorColor: UiUtil.currentTheme.accentColor,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: m.common.notes,
                ),
                onChanged: (val) => setState(() => _basicData.notes = val),
                initialValue: _basicData.notes,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              Text(''),
              UiUtil.accessTime(_basicData.accessTime),
              UiUtil.deltaTime(_basicData.deltaTime),
              UiUtil.createTime(_basicData.createTime),
            ],
          ),
        ),
        floatingActionButton: UiUtil.confirmButton(_confirm));
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      if (_changePassword) {
        newSecPassword = Util.encryptPassword(_secKey1, data.key, randomIdx);
      }
      data.basicData = _basicData.clone();
      UiUtil.makeChange(context);
    }
  }
}
