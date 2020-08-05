import 'package:flutter/material.dart';
import 'globals.dart';
import 'ui_utility.dart';
import 'utility.dart';

class PasswordSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Password Settings"),
      ),
      body: new Center(
        child: new PasswordSettingsWidget(),
      ),
    );
  }
}

class PasswordSettingsWidget extends StatefulWidget {
  PasswordSettingsWidget({Key key}) : super(key: key);

  @override
  _PasswordSettingsWidgetState createState() => _PasswordSettingsWidgetState();
}

class _PasswordSettingsWidgetState extends State<PasswordSettingsWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passwordPolicy = data.passwordPolicy.clone();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          UiUtil.spinRow(
              "Minimal length",
              0,
              300,
              _passwordPolicy.minLenght.toDouble(),
              (double newValue) =>
                  setState(() => _passwordPolicy.minLenght = newValue.toInt())),
          UiUtil.spinRow(
              "Minimal digits",
              0,
              300,
              _passwordPolicy.minDigit.toDouble(),
              (double newValue) =>
                  setState(() => _passwordPolicy.minDigit = newValue.toInt())),
          UiUtil.spinRow(
              "Minimal lower case letters",
              0,
              300,
              _passwordPolicy.minLowerCase.toDouble(),
              (double newValue) => setState(
                  () => _passwordPolicy.minLowerCase = newValue.toInt())),
          UiUtil.spinRow(
              "Minimal upper case letters",
              0,
              300,
              _passwordPolicy.minUpperCase.toDouble(),
              (double newValue) => setState(
                  () => _passwordPolicy.minUpperCase = newValue.toInt())),
          UiUtil.spinRow(
              "Minimal symboleletters",
              0,
              300,
              _passwordPolicy.minSymbol.toDouble(),
              (double newValue) =>
                  setState(() => _passwordPolicy.minSymbol = newValue.toInt())),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Allowed symbols",
              hintText: 'Symbol letters',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter speical characters';
              }
              if (Util.isAlphaNum(value)) {
                return 'Only speical characters';
              }
              return null;
            },
            onChanged: (val) =>
                setState(() => _passwordPolicy.allowedSymbols = val),
            initialValue: _passwordPolicy.allowedSymbols,
          ),
          UiUtil.confirmButton(_confirm),
        ],
      ),
    );
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      data.passwordPolicy = _passwordPolicy.clone();
      UiUtil.confirmAll(context);
    }
  }
}
