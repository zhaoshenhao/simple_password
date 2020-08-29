import 'package:flutter/material.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';

class BackupSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.common.settings),
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
  final _securityPolicy = data.securityPolicy.clone();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: new ListView(
            padding: UiUtil.edgeInsets,
            children: <Widget>[
              UiUtil.headingRow(m.settings.bk),
              SwitchListTile(
                title: Text(m.settings.bkB4Save),
                value: _backupPolicy.autoBackup,
                onChanged: (bool val) => setState(() {
                  if (!readOnly) {
                    _backupPolicy.autoBackup = val;
                  }
                }),
              ),
              SwitchListTile(
                title: Text(m.settings.keepLastDay),
                value: _backupPolicy.keepOneDay,
                onChanged: (bool val) => setState(() {
                  if (!readOnly) {
                    _backupPolicy.keepOneDay = val;
                  }
                }),
              ),
              SwitchListTile(
                title: Text(m.settings.keepLastWeek),
                value: _backupPolicy.keepLastWeek,
                onChanged: (bool val) => setState(() {
                  if (!readOnly) {
                    _backupPolicy.keepLastWeek = val;
                  }
                }),
              ),
              SwitchListTile(
                title: Text(m.settings.keepLastMonth),
                value: _backupPolicy.keepLastMonth,
                onChanged: (bool val) => setState(() {
                  if (!readOnly) {
                    _backupPolicy.keepLastMonth = val;
                  }
                }),
              ),
              UiUtil.spinRow(
                  m.settings.totalBks,
                  0,
                  100,
                  _backupPolicy.totalBackups.toDouble(),
                  (double newValue) => setState(() {
                        if (!readOnly) {
                          _backupPolicy.totalBackups = newValue.toInt();
                        }
                      })),
              UiUtil.headingRow(m.settings.sec),
              SwitchListTile(
                title: Text(m.settings.autoHide),
                value: _securityPolicy.autoHide,
                onChanged: readOnly
                    ? null
                    : (bool val) =>
                        setState(() => _securityPolicy.autoHide = val),
              ),
              UiUtil.spinRow(
                  m.settings.autoHideInterval,
                  10,
                  300,
                  _securityPolicy.autoHideInterval.toDouble(),
                  (double newValue) => setState(() {
                        if (!readOnly) {
                          _securityPolicy.autoHideInterval = newValue.toInt();
                        }
                      })),
              SwitchListTile(
                title: Text(m.settings.autoSave),
                value: _securityPolicy.autoSave,
                onChanged: readOnly
                    ? null
                    : (bool val) =>
                        setState(() => _securityPolicy.autoSave = val),
              ),
              UiUtil.spinRow(
                  m.settings.autoSaveInterval,
                  60,
                  300,
                  _securityPolicy.autoSaveInterval.toDouble(),
                  (double newValue) => setState(() {
                        if (!readOnly) {
                          _securityPolicy.autoSaveInterval = newValue.toInt();
                        }
                      })),
              Text(''),
              Text(''),
              Text(''),
            ],
          ),
        ),
        floatingActionButton: UiUtil.confirmButton(_confirm));
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      data.backupPolicy = _backupPolicy.clone();
      data.securityPolicy = _securityPolicy.clone();
      UiUtil.confirmAll(context);
    }
  }
}
