import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dart:io';
import 'file_utility.dart';
import 'globals.dart';
import 'save_utility.dart';
import 'ui_utility.dart';
import 'utility.dart';

class SaveAndBackupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Save & Backup & Share"),
      ),
      body: new Center(
        child: new SaveAndBackupWidget(),
      ),
    );
  }
}

class SaveAndBackupWidget extends StatefulWidget {
  SaveAndBackupWidget({Key key}) : super(key: key);

  @override
  _SaveAndBackupWidgetState createState() => _SaveAndBackupWidgetState();
}

class _SaveAndBackupWidgetState extends State<SaveAndBackupWidget> {
  bool _useBackupPolicy = true;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      //padding: UiUtil.edgeInsets,
      children: _getList(),
    );
  }

  Future<void> _backup() async {
    String password = Util.decryptPassword(secPassword, data.key, randomIdx);
    if (FileUtil.backup(currentFilename, data, password)) {
      setState(() {});
      Scaffold.of(context).showSnackBar(
          UiUtil.snackBar("New backup of $currentFilename.sp is done."));
    } else {
      Scaffold.of(context).showSnackBar(
          UiUtil.snackBar("Taking backup of $currentFilename.sp failed!"));
    }
  }

  Future<void> _cleanBackup() async {
    bool yes = await UiUtil.confirm(
        "Confirm",
        "Perform backup policy of\n$currentFilename.sp?\nSome old backups will be removed.",
        context);
    if (yes) {
      FileUtil.applyBackupPolicy(data.backupPolicy, currentFilename);
      setState(() {});
      Scaffold.of(context)
          .showSnackBar(UiUtil.snackBar("Backup policy performed."));
    }
  }

  Future<void> _delete(String f) async {
    bool yes = await UiUtil.confirm("Confirm", "Delete $f.sp?", context);
    if (yes) {
      FileUtil.deleteFileInDocDir(f);
      setState(() {});
      Scaffold.of(context).showSnackBar(UiUtil.snackBar("File $f.sp deleted"));
    }
  }

  List<Widget> _getFiles() {
    List<String> files = FileUtil.listSpFiles();
    if (files == null || files.isEmpty) {
      return List();
    }
    files.remove(currentFilename);
    files.sort((a, b) => a.compareTo(b));
    return files.map((e) => _getItem(e)).toList();
  }

  Slidable _getItem(String f) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
          color: Colors.white,
          child: ListTile(
            title: new Text(
              "$f.sp",
              style: UiUtil.biggerFont,
            ),
          )),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async => _delete(f),
        ),
      ],
    );
  }

  List<Widget> _getList() {
    List<Widget> list = List();
    list.add(Container(
        padding: UiUtil.edgeInsets,
        child: UiUtil.headingRow("Password file status")));
    list.add(Container(
        padding: UiUtil.edgeInsets2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("File: $currentFilename.sp"),
            Text("Read-only mode: $readOnly"),
            Text("Total changes: $changes"),
          ],
        )));
    list.add(Divider());
    list.add(Container(
        padding: UiUtil.edgeInsets2,
        child: Row(children: <Widget>[
          Expanded(
              child: Text("Save with backup policy",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          ToggleSwitch(
            initialLabelIndex: _useBackupPolicy ? 0 : 1,
            minWidth: 80.0,
            cornerRadius: 10.0,
            minHeight: 25,
            activeBgColor: Colors.red,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            labels: ['Yes', 'No'],
            icons: [Icons.lock, Icons.lock_open],
            onToggle: (index) {
              _useBackupPolicy = (index == 0);
            },
          )
        ])));
    list.add(Text(''));
    list.add(Center(
        child: RaisedButton.icon(
      icon: Icon(Icons.save),
      onPressed: readOnly || changes == 0 ? null : () async => _save(),
      color: Colors.red,
      textColor: Colors.white,
      label: Text('Save'),
    )));
    list.add(Container(
        padding: UiUtil.edgeInsets, child: UiUtil.headingRow("Actions")));
    list.add(Center(
        child: Container(
            width: 220.0,
            child: RaisedButton.icon(
                icon: Icon(Icons.share),
                onPressed: () async => _share(),
                color: Colors.red,
                textColor: Colors.white,
                label: Text('Share Current File')))));
    list.add(Center(
        child: Container(
            width: 220.0,
            child: RaisedButton.icon(
                icon: Icon(Icons.content_copy),
                onPressed: () async => _backup(),
                color: Colors.red,
                textColor: Colors.white,
                label: Text('Backup Current File')))));
    list.add(Center(
        child: Container(
            width: 220.0,
            child: RaisedButton.icon(
              icon: Icon(Icons.delete_sweep),
              onPressed: () async => _cleanBackup(),
              color: Colors.red,
              textColor: Colors.white,
              label: Text('Perform Backup Policy'),
            ))));
    list.add(Container(
        padding: UiUtil.edgeInsets,
        child: UiUtil.headingRow("Backup cleanup")));
    list.addAll(_getFiles());
    return list;
  }

  Future<void> _save() async {
    bool ret = await SaveUtil.save(context, useBackupPolicy: _useBackupPolicy);
    if (ret == null) {
      return;
    }
    if (ret) {
      Scaffold.of(context).showSnackBar(UiUtil.snackBar("Changes saved"));
      setState(() {});
    } else {
      Scaffold.of(context)
          .showSnackBar(UiUtil.snackBar("Saving changes failed."));
    }
  }

  Future<void> _share() async {
    String p = Util.getPath(currentFilename);
    if (Platform.isAndroid) {
      String p2 = Util.getTmpPath(currentFilename);
      if (FileUtil.copyToTmp(p, p2)) {
        p = p2;
      } else {
        Scaffold.of(context)
            .showSnackBar(UiUtil.snackBar("Sharing file failed."));
        return;
      }
    }
    bool ret = await FlutterShare.shareFile(
      title: 'Simple Password',
      text: 'This is the simple password file.',
      filePath: p,
    );
    String msg;
    if (ret) {
      msg = "Sharing completed";
    } else {
      msg = "Sharing failed";
    }
    Scaffold.of(context).showSnackBar(UiUtil.snackBar(msg));
    print("share");
  }
}
