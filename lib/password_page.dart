import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

int pgindex;
int pindex;
Password _password;
Group _tgroup;

class OnePasswordPage extends StatelessWidget {
  OnePasswordPage(int pi, int pgi, Group group) {
    pindex = pi;
    pgindex = pgi;
    _tgroup = group;
    Password p = group.passwords[pi];
    p.basicData.accessTime = DateTime.now();
    _password = p.clone();
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
  Timer _timer;
  int _start = data.securityPolicy.autoHideInterval;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Form(
          key: _formKey,
          child: new ListView(
            padding: UiUtil.edgeInsets,
            children: <Widget>[
              TextFormField(
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
                        color: UiUtil.priColor,
                      )),
                ),
                onChanged: (val) => {_password.username = val},
                controller: username,
              ),
              TextFormField(
                readOnly: readOnly,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: m.common.password,
                  hintText: m.pswd.pswdHint2,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _togglevisibility();
                    },
                    child: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: UiUtil.priColor,
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
                        color: UiUtil.priColor,
                      )),
                ),
                onChanged: (val) => {_password.password = val},
                controller: pswd,
                obscureText: !_showPassword,
              ),
              _getPasswordButtons(),
              TextFormField(
                readOnly: readOnly,
                keyboardType: TextInputType.text,
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
                        color: UiUtil.priColor,
                      )),
                ),
                onChanged: (val) => {_password.url = val},
                controller: url,
              ),
              TextFormField(
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

  void cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  @protected
  void initState() {
    pswd = TextEditingController(text: _password.password);
    username = TextEditingController(text: _password.username);
    url = TextEditingController(text: _password.url);
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    if (!data.securityPolicy.autoHide ||
        data.securityPolicy.autoHideInterval <= 0) {
      return;
    }
    _start = data.securityPolicy.autoHideInterval;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start < 1) {
        timer.cancel();
        //_showPassword = false;
        _togglevisibility();
      } else {
        _start = _start - 1;
      }
    });
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
      _tgroup.passwords[pindex] = tmp;
      data.groups[pgindex] = _tgroup.clone();
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
          color: readOnly ? UiUtil.disColor : Colors.white60,
          onPressed: readOnly ? null : () => _resetPassword(),
          child: Text(m.common.reset),
        ),
        new RaisedButton(
            color: readOnly ? UiUtil.disColor : Colors.white60,
            onPressed: readOnly ? null : () => _genPassword(),
            child: Text(m.common.gen)),
        new RaisedButton(
          color: Colors.white60,
          onPressed: () => _checkPassword(),
          child: Text(m.common.check),
        ),
      ],
    );
  }

  void _resetPassword() {
    pswd.text = Util.decryptPassword(
        _tgroup.passwords[pindex].password, data.key, _password.key);
    _password.password = pswd.text;
  }

  void _showResult(List<String> list) {
    String message = list.isEmpty ? m.pswd.pswdGood : "\n" + list.join("\n");
    dialog.showOkAlertDialog(
        context: context,
        title: m.pswd.pswdCheck,
        message: message,
        alertStyle: dialog.AdaptiveStyle.material);
  }

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
      if (_showPassword) {
        startTimer();
      } else {
        cancelTimer();
      }
    });
  }
}
