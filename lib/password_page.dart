import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'globals.dart';
import 'ui_utility.dart';
import 'utility.dart';

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
        title: Text("Password Detail"),
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
                decoration: const InputDecoration(
                  labelText: "Title",
                  hintText: 'The item title',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter something';
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
                  hintText: 'The username',
                  prefixIcon: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: username.text));
                        Scaffold.of(context)
                            .showSnackBar(UiUtil.snackBar("Username copied"));
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: Colors.red,
                      )),
                ),
                onChanged: (val) => {_password.username = val},
                controller: username,
              ),
              TextFormField(
                readOnly: readOnly,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: 'Enter your password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _togglevisibility();
                    },
                    child: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.red,
                    ),
                  ),
                  prefixIcon: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: pswd.text));
                        Scaffold.of(context)
                            .showSnackBar(UiUtil.snackBar("Password copied"));
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: Colors.red,
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
                  labelText: "URL",
                  hintText: 'Any URL',
                  prefixIcon: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: url.text));
                        Scaffold.of(context)
                            .showSnackBar(UiUtil.snackBar("URL copied"));
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: Colors.red,
                      )),
                ),
                onChanged: (val) => {_password.url = val},
                controller: url,
              ),
              TextFormField(
                readOnly: readOnly,
                decoration: const InputDecoration(
                  labelText: 'Notes',
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
    List<String> list = Util.checkPassword(pswd.text, data.passwordPolicy);
    _showResult(list);
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
          color: readOnly ? Colors.grey : Colors.white60,
          onPressed: readOnly ? null : () => _resetPassword(),
          child: Text('Reset'),
        ),
        new RaisedButton(
            color: readOnly ? Colors.grey : Colors.white60,
            onPressed: readOnly ? null : () => _genPassword(),
            child: Text('Generate')),
        new RaisedButton(
          color: Colors.white60,
          onPressed: () => _checkPassword(),
          child: Text('Check'),
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
    String message =
        list.isEmpty ? "Password looks good." : "\n" + list.join("\n");
    dialog.showOkAlertDialog(
        context: context, title: 'Password Check', message: message);
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
