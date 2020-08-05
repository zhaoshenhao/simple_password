import 'dart:async';

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
    pswd = TextEditingController(text: _password.password);
    username = TextEditingController(text: _password.username);
    url = TextEditingController(text: _password.url);
    return Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          TextFormField(
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
            onChanged: (val) => setState(() => _password.basicData.name = val),
            initialValue: _password.basicData.name,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Username",
              hintText: 'The username',
              suffixIcon: GestureDetector(
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
            onChanged: (val) => setState(() => _password.username = val),
            controller: username,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: 'Enter your password',
              prefixIcon: GestureDetector(
                onTap: () {
                  _togglevisibility();
                },
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.red,
                ),
              ),
              suffixIcon: GestureDetector(
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
            onChanged: (val) => setState(() => _password.password = val),
            controller: pswd,
            obscureText: !_showPassword,
          ),
          _getPasswordButtons(),
          TextFormField(
            decoration: InputDecoration(
              labelText: "URL",
              hintText: 'Any URL',
              suffixIcon: GestureDetector(
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
            onChanged: (val) => setState(() => _password.url = val),
            controller: url,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
            onChanged: (val) => setState(() => _password.basicData.notes = val),
            initialValue: _password.basicData.notes,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          Text(''),
          UiUtil.accessTime(_password.basicData.accessTime),
          UiUtil.deltaTime(_password.basicData.deltaTime),
          UiUtil.createTime(_password.basicData.createTime),
          UiUtil.confirmButton(_confirm),
        ],
      ),
    );
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    if (!data.securityPolicy.autoHide ||
        data.securityPolicy.autoHideInterval <= 0) {
      return;
    }
    _start = data.securityPolicy.autoHideInterval;
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _showPassword = false;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void _checkPassword() {
    // TODO
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      _password.basicData.deltaTime = DateTime.now();
      _tgroup.basicData.deltaTime = DateTime.now();
      _tgroup.passwords[pindex] = _password.clone();
      data.groups[pgindex] = _tgroup.clone();
      setState(() {});
      UiUtil.confirmAll(context);
    }
  }

  void _genPassword() {
    pswd.text = Util.genPassword();
  }

  Widget _getPasswordButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RaisedButton(
          onPressed: () => _resetPassword(),
          child: Text('Reset'),
        ),
        new RaisedButton(
            onPressed: () => _genPassword(), child: Text('Generate')),
        new RaisedButton(
          onPressed: () => _checkPassword(),
          child: Text('Check'),
        ),
      ],
    );
  }

  void _resetPassword() {
    pswd.text = _tgroup.passwords[pindex].password;
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
