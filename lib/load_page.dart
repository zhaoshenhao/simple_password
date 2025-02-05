import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:simple_password/create_page.dart';
import 'package:simple_password/file_utility.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/local_auth_utility.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/save_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: m.common.appName(IapUtil.isPaid),
        theme: UiUtil.currentTheme,
        home: new Scaffold(
          appBar: AppBar(
            title: Text(m.common.appName(IapUtil.isPaid)),
          ),
          body: new Center(
            child: new LoadPageWidget(),
          ),
        ));
  }
}

class LoadPageWidget extends StatefulWidget {
  LoadPageWidget({Key key}) : super(key: key);

  @override
  _LoadPageWidgetState createState() => _LoadPageWidgetState();
}

class _LoadPageWidgetState extends State<LoadPageWidget> {
  static final String noneFile = "-- ${m.common.none} --";
  bool _showPassword = false;
  bool hasHistory = true;
  String otherFile;
  List<String> historyFiles;
  String choosed = noneFile;
  String secKey;
  double _twidth = 200;

  @override
  Widget build(BuildContext context) {
    _twidth = MediaQuery.of(context).size.width - 170;

    List<DropdownMenuItem<String>> hist = _getHistory();
    return new ListView(
      padding: UiUtil.edgeInsets,
      children: <Widget>[
        UiUtil.headingRow(m.load.loadPswdFile),
        Row(children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: 65, maxWidth: 65),
              child: Text(m.common.recent)),
          Expanded(
              child: IgnorePointer(
                  ignoring: !hasHistory,
                  child: DropdownButton<String>(
                    value: choosed,
                    items: hist,
                    onChanged: (value) => setState(() {
                      choosed = value;
                    }),
                  ))),
          Container(
              constraints: BoxConstraints(minWidth: 30, maxWidth: 45),
              child: IconButton(
                  icon: Icon(Icons.folder_open),
                  tooltip: m.load.openOther,
                  color: UiUtil.currentTheme.accentColor,
                  onPressed: () async => _openFile())),
        ]),
        TextFormField(
          cursorColor: UiUtil.currentTheme.accentColor,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: m.pswd.msKey,
              hintText: m.pswd.pswdHint,
              suffixIcon: GestureDetector(
                onLongPressStart: (details) {
                  _showPassword = true;
                  setState(() {});
                },
                onLongPressEnd: (details) {
                  _showPassword = false;
                  setState(() {});
                },
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: UiUtil.currentTheme.accentColor,
                ),
              )),
          obscureText: !_showPassword,
          onChanged: (val) => {secKey = val},
        ),
        Text(''),
        Row(children: <Widget>[
          Expanded(
              child: Text(m.load.openInRo,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          ToggleSwitch(
            initialLabelIndex: readOnly ? 0 : 1,
            minWidth: 80.0,
            cornerRadius: 10.0,
            minHeight: 25,
            labels: [m.common.on, m.common.off],
            icons: [Icons.lock, Icons.lock_open],
            inactiveFgColor: UiUtil.currentTheme.disabledColor,
            activeBgColor: UiUtil.currentTheme.accentColor,
            onToggle: (index) {
              readOnly = (index == 0);
            },
          )
        ]),
        Text(''),
        Divider(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buttons(),
        ),
      ],
    );
  }

  Widget _getBioButton() {
    if (currentFilename == null || !IapUtil.isPaid) {
      return null;
    }
    Icon icon;
    if (LocalAuthUtil.allowFace) {
      icon = Icon(Icons.face);
    } else if (LocalAuthUtil.allowFingerPrint) {
      icon = Icon(Icons.fingerprint);
    }
    if (icon != null) {
      return (IconButton(
        icon: icon,
        color: UiUtil.currentTheme.accentColor,
        onPressed: _canUseLocalAuth() ? () async => _localAuth() : null,
      ));
    }
    return null;
  }

  List<Widget> _buttons() {
    List<Widget> list = List();
    Widget bioButton = _getBioButton();
    if (bioButton != null) {
      list.add(bioButton);
    }
    list.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
          width: 125,
          child: RaisedButton.icon(
            icon: Icon(Icons.lock_open),
            onPressed: hasHistory ? () => _loadAndUnlock() : null,
            label: Expanded(child: Text(m.load.loadFile)),
            color: UiUtil.currentTheme.primaryColor,
            textColor: UiUtil.currentTheme.buttonColor,
          )),
      Container(
          width: 125,
          child: RaisedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _newFile(),
            label: Expanded(child: Text(m.load.newFile)),
            color: UiUtil.currentTheme.primaryColor,
            textColor: UiUtil.currentTheme.buttonColor,
          ))
    ]));
    return list;
  }

  bool _canUseLocalAuth() {
    return currentFilename == choosed && IapUtil.isPaid;
  }

  void _localAuth() async {
    int ret = await LocalAuthUtil.check(m.load.auth);
    if (ret == 0) {
      Log.fine("Open file with device auth");
      _unlock(current: true);
    } else if (ret == -1) {
      UiUtil.alert(
          m.common.error,
          m.load.authErr + "\nSystem Error:\n" + LocalAuthUtil.error.toString(),
          context);
    }
  }

  List<DropdownMenuItem<String>> _getHistory() {
    List<String> historyFiles = List();
    List<String> list1 = Util.getHistoryFiles();

    List<String> list2 = FileUtil.listSpFiles();
    if (list1 != null) {
      historyFiles.addAll(list1);
    }
    if (list2 != null) {
      for (String f in list2) {
        if (!historyFiles.contains(f)) {
          historyFiles.add(f);
        }
      }
    }
    if (otherFile != null) {
      historyFiles.insert(0, otherFile);
    }
    hasHistory = historyFiles.isNotEmpty;
    if (hasHistory) {
      if (!historyFiles.contains(choosed)) {
        choosed = historyFiles.first;
      }
    } else {
      historyFiles.add(choosed);
    }
    List<DropdownMenuItem<String>> x;
    if (hasHistory) {
      x = historyFiles.map((String value) {
        String str = value;
        if (value.endsWith(Util.ext)) {
          str = "* " + Util.getBasename(value);
        }
        return new DropdownMenuItem<String>(
          value: value,
          child: _getText(str),
        );
      }).toList();
    } else {
      x = List();
      x.add(new DropdownMenuItem<String>(
        value: choosed,
        child: _getText(choosed),
      ));
    }
    return x;
  }

  Widget _getText(String text) {
    return new Container(width: _twidth, child: Text(text));
  }

  List<AlertDialogAction<int>> _getActions() {
    List<AlertDialogAction<int>> list = List();
    list.add(new AlertDialogAction(
      key: 0,
      label: m.load.oldOverwritten,
    ));
    list.add(new AlertDialogAction(
      key: 1,
      label: m.load.oldRename,
    ));
    return list;
  }

  void _loadAndUnlock() async {
    bool isExtFile = !Util.isInCurrentDir(choosed);
    String bf = Util.getBasename(choosed);
    bool isCurrentFile = (currentFilename == choosed);
    if (!isCurrentFile && changes > 0) {
      // Check existing changes
      UiUtil.alert(m.common.unsaved, m.common.unsavedMsg, context);
      return;
    }
    if (isCurrentFile) {
      // reopen file
      Log.fine("${m.file.loadCurrent}: $choosed");
      String password = Util.decryptPassword(secPassword, data.key, randomIdx);
      if (password == secKey) {
        _unlock(current: true);
      } else {
        UiUtil.alert(m.common.error, m.pswd.pswdHint, context);
      }
      return;
    }
    if (isExtFile) {
      // Open ext file
      Log.fine("${m.file.loadNew}: $choosed");
      String p = Util.getPath(bf);
      int i;
      if (FileUtil.fileExist(p)) {
        // dup file name in app container
        i = await showConfirmationDialog<int>(
            context: context,
            title: m.common.confirm,
            message: m.file.fileExists,
            okLabel: m.common.confirm,
            cancelLabel: m.common.cancel,
            style: AdaptiveStyle.material,
            actions: _getActions());
        if (i == null || i < 0 || i > 1) {
          return;
        }
      }
      if (SaveUtil.load(choosed, secKey, context)) {
        // i = 0: overwrite, i = 1: auto-rename old
        choosed = FileUtil.makeCopy(choosed, i);
        _unlock();
      }
      return;
    }
    String path = Util.getPath(choosed);
    if (SaveUtil.load(path, secKey, context)) {
      Log.fine("${m.file.loadNew}: $choosed");
      _unlock();
    }
  }

  Future<void> _newFile() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => CreatePage()))
        .then((value) => setState(() {}));
  }

  void _openFile() async {
    FilePickerResult f = await FilePicker.platform.pickFiles();
    if (f == null) {
      return;
    }
    otherFile = f.files.single.path;
    choosed = otherFile;
    setState(() {});
  }

  void _unlock({bool current: false}) {
    if (current) {
      AppLock.of(context).didUnlock();
      return;
    }
    changes = 0;
    currentFilename = choosed;
    randomIdx = Util.randomKey();
    secPassword = Util.encryptPassword(secKey, data.key, randomIdx);
    newSecPassword = null;
    historyFiles = Util.getHistoryFiles();
    List<String> list = List();
    for (String f in historyFiles) {
      String path = Util.getPath(f);
      if (FileUtil.fileExist(path)) {
        list.add(f);
      }
    }
    historyFiles = list;
    if (historyFiles.contains(currentFilename)) {
      historyFiles.remove(currentFilename);
    }
    historyFiles.insert(0, currentFilename);
    Util.setHistoryFiles(historyFiles);
    AppLock.of(context).didUnlock();
  }
}
