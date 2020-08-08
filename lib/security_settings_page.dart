import 'package:flutter/material.dart';
import 'globals.dart';
import 'ui_utility.dart';

class SecuritySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Security Settings"),
      ),
      body: new Center(
        child: new SecuritySettingsWidget(),
      ),
    );
  }
}

class SecuritySettingsWidget extends StatefulWidget {
  SecuritySettingsWidget({Key key}) : super(key: key);

  @override
  _SecuritySettingsWidgetState createState() => _SecuritySettingsWidgetState();
}

class _SecuritySettingsWidgetState extends State<SecuritySettingsWidget> {
  final _formKey = GlobalKey<FormState>();
  final _securityPolicy = data.securityPolicy.clone();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Auto-hide password'),
            value: _securityPolicy.autoHide,
            onChanged: readOnly
                ? null
                : (bool val) => setState(() => _securityPolicy.autoHide = val),
          ),
          UiUtil.spinRow(
              "Auto-hide interval(seconds)",
              10,
              300,
              _securityPolicy.autoHideInterval.toDouble(),
              (double newValue) => setState(
                  () => _securityPolicy.autoHideInterval = newValue.toInt())),
          SwitchListTile(
            title: const Text('Auto-save changes'),
            value: _securityPolicy.autoSave,
            onChanged: readOnly
                ? null
                : (bool val) => setState(() => _securityPolicy.autoSave = val),
          ),
          UiUtil.spinRow(
              "Auto-save interval(seconds)",
              60,
              300,
              _securityPolicy.autoSaveInterval.toDouble(),
              (double newValue) => setState(
                  () => _securityPolicy.autoSaveInterval = newValue.toInt())),
          UiUtil.confirmButton(_confirm),
        ],
      ),
    );
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      data.securityPolicy = _securityPolicy.clone();
      UiUtil.confirmAll(context);
    }
  }
}
