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
import 'package:adaptive_dialog/adaptive_dialog.dart';

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

  List<DialogTextField> _getInput(String f) {
    List<DialogTextField> list = List();
    list.add(DialogTextField(
      initialText: f,
      validator: (value) {
        if (value == null || value == '') {
          return m.common.notEmpty;
        }
        if (value == f) {
          return m.common.noChange;
        }
        return null;
      },
    ));
    return list;
  }

  Future<void> _rename(String f1) async {
    List<String> fns = await showTextInputDialog(
      title: m.common.rename,
      message: m.sbs.newName,
      context: context,
      style: AdaptiveStyle.material,
      textFields: _getInput(f1),
    );
    if (fns == null || fns.isEmpty) {
      return;
    }
    String f2 = fns[0];
    if (f2 == null || f2 == '') {
      return;
    }
    String p2 = Util.getPath(f2);
    if (FileUtil.fileExist(p2)) {
      UiUtil.alert(m.common.error, m.file.fileExistErr(f2), context);
    } else {
      if (FileUtil.rename(f1, f2)) {
        Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.common.renameGood));
      } else {
        Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.common.renameBad));
      }
    }
    setState(() {});
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
          child: ListTile(
        title: new Text(
          "$f.sp",
          style: UiUtil.biggerFont,
        ),
      )),
      actions: <Widget>[
        IconSlideAction(
          caption: m.common.delete,
          icon: Icons.delete,
          color: UiUtil.currentTheme.accentColor,
          onTap: () async => _delete(f),
        ),
        IconSlideAction(
          caption: m.common.rename,
          icon: Icons.text_fields,
          color: UiUtil.currentTheme.accentColor,
          onTap: () async => _rename(f),
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
            labels: [m.common.yes, m.common.no],
            icons: [Icons.lock, Icons.lock_open],
            inactiveFgColor: UiUtil.currentTheme.disabledColor,
            activeBgColor: UiUtil.currentTheme.accentColor,
            onToggle: (index) {
              _useBackupPolicy = (index == 0);
            },
          )
        ])));
    list.add(Text(''));
    list.add(Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      RaisedButton.icon(
        icon: Icon(Icons.save),
        color: UiUtil.currentTheme.primaryColor,
        textColor: UiUtil.currentTheme.buttonColor,
        onPressed: readOnly || changes == 0 ? null : () async => _save(),
        label: Text(m.common.save),
      ),
      RaisedButton.icon(
        icon: Icon(Icons.clear),
        color: UiUtil.currentTheme.primaryColor,
        textColor: UiUtil.currentTheme.buttonColor,
        onPressed: readOnly || changes == 0 ? null : () async => _discard(),
        label: Text(m.common.discard),
      ),
    ])));
    list.add(Container(
        padding: UiUtil.edgeInsets,
        child: UiUtil.headingRow(m.common.actions)));
    list.add(Center(
        child: Container(
            width: 250.0,
            child: RaisedButton.icon(
                color: UiUtil.currentTheme.primaryColor,
                textColor: UiUtil.currentTheme.buttonColor,
                icon: Icon(Icons.share),
                onPressed: () async => _share(),
                label: Expanded(child: Text(m.sbs.shareCurrent))))));
    list.add(Center(
        child: Container(
            width: 250.0,
            child: RaisedButton.icon(
                color: UiUtil.currentTheme.primaryColor,
                textColor: UiUtil.currentTheme.buttonColor,
                icon: Icon(Icons.content_copy),
                onPressed: () async => _backup(),
                label: Expanded(child: Text(m.sbs.bkCurrent))))));
    list.add(Center(
        child: Container(
            width: 250.0,
            child: RaisedButton.icon(
              color: UiUtil.currentTheme.primaryColor,
              textColor: UiUtil.currentTheme.buttonColor,
              icon: Icon(Icons.delete_sweep),
              onPressed: () async => _cleanBackup(),
              label: Expanded(child: Text(m.sbs.doPolicy1)),
            ))));
    list.add(Container(
        padding: UiUtil.edgeInsets, child: UiUtil.headingRow(m.sbs.bkClean)));
    list.addAll(_getFiles());
    return list;
  }

  Future<void> _discard() async {
    if (await SaveUtil.discard(context)) {
      Util.localeChangeCallback();
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.common.discardDone));
    }
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
      title: currentFilename + Util.ext,
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
