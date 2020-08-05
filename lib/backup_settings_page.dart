import 'package:flutter/material.dart';
import 'globals.dart';
import 'ui_utility.dart';

class BackupSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Backup Settings"),
      ),
      body: new Center(
        child: new BackupSettingsWidget(),
      ),
    );
  }
}

class BackupSettingsWidget extends StatefulWidget {
  BackupSettingsWidget({Key key}) : super(key: key);

  @override
  _BackupSettingsWidgetState createState() => _BackupSettingsWidgetState();
}

class _BackupSettingsWidgetState extends State<BackupSettingsWidget> {
  final _formKey = GlobalKey<FormState>();
  final _backupPolicy = data.backupPolicy.clone();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Create backup before saving'),
            value: _backupPolicy.autoBackup,
            onChanged: (bool val) =>
                setState(() => _backupPolicy.autoBackup = val),
          ),
          SwitchListTile(
            title: const Text('Keep backup for yesterday'),
            value: _backupPolicy.keepOneDay,
            onChanged: (bool val) =>
                setState(() => _backupPolicy.keepOneDay = val),
          ),
          SwitchListTile(
            title: const Text('Keep backup for last week'),
            value: _backupPolicy.keepLastWeek,
            onChanged: (bool val) =>
                setState(() => _backupPolicy.keepLastWeek = val),
          ),
          SwitchListTile(
            title: const Text('Keep backup for last month'),
            value: _backupPolicy.keepLastMonth,
            onChanged: (bool val) =>
                setState(() => _backupPolicy.keepLastMonth = val),
          ),
          UiUtil.spinRow(
              "Total backups",
              0,
              100,
              _backupPolicy.totalBackups.toDouble(),
              (double newValue) => setState(
                  () => _backupPolicy.totalBackups = newValue.toInt())),
          UiUtil.confirmButton(_confirm),
        ],
      ),
    );
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      data.backupPolicy = _backupPolicy.clone();
      UiUtil.confirmAll(context);
    }
  }
}
