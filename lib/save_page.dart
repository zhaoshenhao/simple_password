import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_password/file_utility.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/save_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SaveAndBackupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.sbs.title),
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
      Scaffold.of(context)
          .showSnackBar(UiUtil.snackBar(m.sbs.bkDone(currentFilename)));
    } else {
      Scaffold.of(context)
          .showSnackBar(UiUtil.snackBar(m.sbs.bkFailed(currentFilename)));
    }
  }

  Future<void> _cleanBackup() async {
    bool yes = await UiUtil.confirm(
        m.common.confirm, m.sbs.doPolicy(currentFilename), context);
    if (yes) {
      FileUtil.applyBackupPolicy(data.backupPolicy, currentFilename);
      setState(() {});
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.sbs.donePolicy));
    }
  }

  Future<void> _delete(String f) async {
    bool yes =
        await UiUtil.confirm(m.common.confirm, m.sbs.deleteAsk(f), context);
    if (yes) {
      FileUtil.deleteFileInDocDir(f);
      setState(() {});
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.sbs.fileDeleted(f)));
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
          caption: m.common.delete,
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
        child: UiUtil.headingRow(m.sbs.pswdFileStatus)));
    list.add(Container(
        padding: UiUtil.edgeInsets2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${m.common.file}: $currentFilename.sp"),
            Text("${m.sbs.roMode}: $readOnly"),
            Text("${m.sbs.totalChanges}: $changes"),
          ],
        )));
    list.add(Divider());
    list.add(Container(
        padding: UiUtil.edgeInsets2,
        child: Row(children: <Widget>[
          Expanded(
              child: Text(m.sbs.sbp,
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
            labels: [m.common.yes, m.common.no],
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
      label: Text(m.common.save),
    )));
    list.add(Container(
        padding: UiUtil.edgeInsets,
        child: UiUtil.headingRow(m.common.actions)));
    list.add(Center(
        child: Container(
            width: 220.0,
            child: RaisedButton.icon(
                icon: Icon(Icons.share),
                onPressed: () async => _share(),
                color: Colors.red,
                textColor: Colors.white,
                label: Text(m.sbs.shareCurrent)))));
    list.add(Center(
        child: Container(
            width: 220.0,
            child: RaisedButton.icon(
                icon: Icon(Icons.content_copy),
                onPressed: () async => _backup(),
                color: Colors.red,
                textColor: Colors.white,
                label: Text(m.sbs.bkCurrent)))));
    list.add(Center(
        child: Container(
            width: 220.0,
            child: RaisedButton.icon(
              icon: Icon(Icons.delete_sweep),
              onPressed: () async => _cleanBackup(),
              color: Colors.red,
              textColor: Colors.white,
              label: Text(m.sbs.doPolicy1),
            ))));
    list.add(Container(
        padding: UiUtil.edgeInsets, child: UiUtil.headingRow(m.sbs.bkClean)));
    list.addAll(_getFiles());
    return list;
  }

  Future<void> _save() async {
    bool ret = await SaveUtil.save(context, useBackupPolicy: _useBackupPolicy);
    if (ret == null) {
      return;
    }
    if (ret) {
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.common.chgSaved));
      setState(() {});
    } else {
      Scaffold.of(context)
          .showSnackBar(UiUtil.snackBar(m.common.chgSaveFailed));
    }
  }

  Future<void> _share() async {
    String p = Util.getPath(currentFilename);
    if (Platform.isAndroid) {
      String p2 = Util.getTmpPath(currentFilename);
      if (FileUtil.copyToTmp(p, p2)) {
        p = p2;
      } else {
        Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.sbs.shareFailed));
        return;
      }
    }
    bool ret = await FlutterShare.shareFile(
      title: m.common.appName,
      text: m.sbs.shareContent,
      filePath: p,
    );
    String msg;
    if (ret) {
      msg = m.sbs.shareDone;
    } else {
      msg = m.sbs.shareFailed;
    }
    Scaffold.of(context).showSnackBar(UiUtil.snackBar(msg));
  }
}
