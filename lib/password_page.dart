import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

Password _password;
Group _tgroup;
Group _og;
Password _op;

class OnePasswordPage extends StatelessWidget {
  OnePasswordPage(Password password, Group group, Group og) {
    _tgroup = group;
    _og = og;
    _op = password;
    _password = _op.clone();
    _password.basicData.accessTime = DateTime.now();
    String tmp = _password.password;
    _password.password = Util.decryptPassword(tmp, data.key, _password.key);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.pswd.detail),
      ),
      body: new Center(
        child: new OnePasswordWidget(),
      ),
    );
  }
}

class OnePasswordWidget extends StatefulWidget {
  OnePasswordWidget({Key key}) : super(key: key);

  @override
  _OnePasswordWidgetState createState() => _OnePasswordWidgetState();
}

class _OnePasswordWidgetState extends State<OnePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pswd;
  TextEditingController username;
  TextEditingController url;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Form(
          key: _formKey,
          child: new ListView(
            padding: UiUtil.edgeInsets,
            children: <Widget>[
              TextFormField(
                cursorColor: UiUtil.currentTheme.accentColor,
                readOnly: readOnly,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: m.common.title,
                  hintText: m.pswd.titleHint,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return m.common.notEmpty;
                  }
                  return null;
                },
                onChanged: (val) => {_password.basicData.name = val},
                initialValue: _password.basicData.name,
              ),
              TextFormField(
                cursorColor: UiUtil.currentTheme.accentColor,
                readOnly: readOnly,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: m.pswd.unHint,
                  prefixIcon: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: username.text));
                        Scaffold.of(context)
                            .showSnackBar(UiUtil.snackBar(m.pswd.unCopied));
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: UiUtil.currentTheme.accentColor,
                      )),
                ),
                onChanged: (val) => {_password.username = val},
                controller: username,
              ),
              TextFormField(
                readOnly: readOnly,
                cursorColor: UiUtil.currentTheme.accentColor,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: m.common.password,
                  hintText: m.pswd.pswdHint2,
                  suffixIcon: GestureDetector(
                    onLongPressStart: (details) {
                      _showPassword = true;
                      setState(() {});
                    },
                    onLongPressEnd: (details) {
                      _showPassword = false;
                      setState(() {});
                    },
                    child: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: UiUtil.currentTheme.accentColor,
                    ),
                  ),
                  prefixIcon: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: pswd.text));
                        Scaffold.of(context)
                            .showSnackBar(UiUtil.snackBar(m.pswd.pswdCopied));
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: UiUtil.currentTheme.accentColor,
                      )),
                ),
                onChanged: (val) => {_password.password = val},
                controller: pswd,
                obscureText: !_showPassword,
              ),
              _getPasswordButtons(),
              TextFormField(
                cursorColor: UiUtil.currentTheme.accentColor,
                readOnly: readOnly,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: m.common.url,
                  hintText: m.pswd.urlHint,
                  prefixIcon: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: url.text));
                        Scaffold.of(context)
                            .showSnackBar(UiUtil.snackBar(m.pswd.urlCopied));
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: UiUtil.currentTheme.accentColor,
                      )),
                ),
                onChanged: (val) => {_password.url = val},
                controller: url,
              ),
              TextFormField(
                cursorColor: UiUtil.currentTheme.accentColor,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: m.common.notes,
                ),
                onChanged: (val) => {_password.basicData.notes = val},
                initialValue: _password.basicData.notes,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
              ),
              Text(''),
              UiUtil.accessTime(_password.basicData.accessTime),
              UiUtil.deltaTime(_password.basicData.deltaTime),
              UiUtil.createTime(_password.basicData.createTime),
            ],
          ),
        ),
        floatingActionButton: UiUtil.confirmButton(_confirm));
  }

  @override
  @protected
  void initState() {
    pswd = TextEditingController(text: _password.password);
    username = TextEditingController(text: _password.username);
    url = TextEditingController(text: _password.url);
    super.initState();
  }

  void _checkPassword() {
    List<String> list = _checkPasswordPolicy(pswd.text, data.passwordPolicy);
    _showResult(list);
  }

  List<String> _checkPasswordPolicy(
      String password, PasswordPolicy passwordPolicy) {
    List<String> list = List();
    if (password == null || password == '') {
      list.add(m.pswd.pswdEmpty);
      return list;
    }
    if (password.length < passwordPolicy.minLenght) {
      list.add("${m.pswd.pswdLen} " + passwordPolicy.minLenght.toString());
    }
    int lower = 0;
    int upper = 0;
    int digit = 0;
    int special = 0;
    for (int i = 0; i < password.length; i++) {
      int m = password.codeUnitAt(i);
      if (48 <= m && m <= 57)
        digit += 1;
      else if (65 <= m && m <= 90)
        upper += 1;
      else if (97 <= m && m <= 122)
        lower += 1;
      else
        special += 1;
    }
    if (lower < passwordPolicy.minLowerCase) {
      list.add(m.pswd.containLower(passwordPolicy.minLowerCase));
    }
    if (upper < passwordPolicy.minUpperCase) {
      list.add(m.pswd.containUpper(passwordPolicy.minUpperCase));
    }
    if (digit < passwordPolicy.minDigit) {
      list.add(m.pswd.containDigit(passwordPolicy.minDigit));
    }
    if (special < passwordPolicy.minSymbol) {
      list.add(m.pswd.containSpecial(passwordPolicy.minSymbol));
    }
    return list;
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      DateTime now = DateTime.now();
      _password.basicData.deltaTime = now;
      _tgroup.basicData.deltaTime = now;
      Password tmp = _password.clone();
      String tp = tmp.password;
      tmp.password = Util.encryptPassword(tp, data.key, tmp.key);
      _op.copyFrom(tmp);
      _og.copyFrom(_tgroup);
      setState(() {});
      UiUtil.confirmAll(context);
    }
  }

  void _genPassword() {
    pswd.text = Util.genPassword(data.passwordPolicy);
    _password.password = pswd.text;
  }

  Widget _getPasswordButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RaisedButton(
          color: readOnly
              ? UiUtil.currentTheme.disabledColor
              : UiUtil.currentTheme.primaryColor,
          textColor: UiUtil.currentTheme.buttonColor,
          onPressed: readOnly ? null : () => _resetPassword(),
          child: Text(m.common.reset),
        ),
        new RaisedButton(
            color: readOnly
                ? UiUtil.currentTheme.disabledColor
                : UiUtil.currentTheme.primaryColor,
            textColor: UiUtil.currentTheme.buttonColor,
            onPressed: readOnly ? null : () => _genPassword(),
            child: Text(m.common.gen)),
        new RaisedButton(
          onPressed: () => _checkPassword(),
          color: UiUtil.currentTheme.primaryColor,
          textColor: UiUtil.currentTheme.buttonColor,
          child: Text(m.common.check),
        ),
      ],
    );
  }

  void _resetPassword() {
    pswd.text = Util.decryptPassword(_op.password, data.key, _password.key);
    _password.password = pswd.text;
  }

  void _showResult(List<String> list) {
    String message = list.isEmpty ? m.pswd.pswdGood : "\n" + list.join("\n");
    UiUtil.alert(m.pswd.pswdCheck, message, context);
  }
}
