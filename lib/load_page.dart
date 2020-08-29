import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:simple_password/create_page.dart';
import 'package:simple_password/file_utility.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/local_auth_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: m.common.appName,
        theme: new ThemeData(
          primaryColor: UiUtil.priColor,
        ),
        home: new Scaffold(
          appBar: AppBar(
            title: Text(m.common.appName),
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

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> hist = _getHistory();
    return new ListView(
      padding: UiUtil.edgeInsets,
      children: <Widget>[
        UiUtil.headingRow(m.load.loadPswdFile),
        Row(children: <Widget>[
          Expanded(child: Text(m.common.recent)),
          IgnorePointer(
              ignoring: !hasHistory,
              child: DropdownButton<String>(
                value: choosed,
                items: hist,
                onChanged: (value) => setState(() {
                  choosed = value;
                }),
              )),
          IconButton(
              icon: Icon(Icons.folder_open),
              tooltip: m.load.openOther,
              color: UiUtil.priColor,
              onPressed: () async => _openFile()),
        ]),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: m.pswd.msKey,
              hintText: m.pswd.pswdHint,
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _showPassword = !_showPassword;
                }),
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: UiUtil.priColor,
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
            activeBgColor: UiUtil.priColor,
            activeFgColor: Colors.white,
            inactiveBgColor: UiUtil.disColor,
            inactiveFgColor: Colors.white,
            labels: [m.common.on, m.common.off],
            icons: [Icons.lock, Icons.lock_open],
            onToggle: (index) {
              readOnly = (index == 0);
            },
          )
        ]),
        Text(''),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buttons(),
        ),
      ],
    );
  }

  List<Widget> _buttons() {
    List<Widget> list = List();
    list.add(RaisedButton.icon(
      icon: Icon(Icons.add_circle_outline),
      onPressed: () => _newFile(),
      label: Text(m.load.newFile),
    ));
    list.add(RaisedButton.icon(
      icon: Icon(Icons.lock_open),
      onPressed: hasHistory ? () => _loadAndUnlock() : null,
      color: UiUtil.priColor,
      textColor: Colors.white,
      label: Text(m.load.loadFile),
    ));
    if (currentFilename == null && IapUtil.isPaid()) {
      return list;
    }
    Icon icon;
    if (LocalAuthUtil.allowFace) {
      icon = Icon(Icons.face);
    } else if (LocalAuthUtil.allowFingerPrint) {
      icon = Icon(Icons.fingerprint);
    }
    if (icon != null) {
      list.add(RaisedButton.icon(
          icon: icon,
          onPressed: _canUseLocalAuth() ? () async => _localAuth() : null,
          label: Text(m.load.loadFile)));
    }
    return list;
  }

  bool _canUseLocalAuth() {
    return currentFilename == choosed && IapUtil.isPaid();
  }

  void _localAuth() async {
    int ret = await LocalAuthUtil.check(m.load.auth);
    if (ret == 0) {
      Log.fine("Open file with device auth");
      _unlock(current: true);
    } else if (ret == -1) {
      _alert(
          m.common.error,
          m.load.authErr +
              "\nSystem Error:\n" +
              LocalAuthUtil.error.toString());
    }
  }

  void _alert(String title, String message) async {
    await dialog.showOkAlertDialog(
        context: context,
        title: title,
        message: "\n" + message,
        alertStyle: dialog.AdaptiveStyle.material);
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
          child: new Text(str),
        );
      }).toList();
    } else {
      x = List();
      x.add(new DropdownMenuItem<String>(
        value: choosed,
        child: new Text(choosed),
      ));
    }
    return x;
  }

  bool _load(String path, String secKey) {
    String short = Util.getBasename(path);
    if (!FileUtil.fileExist(path)) {
      _alert(m.file.fileNotFound, m.file.fileNotFoundErr("$short.sp"));
      return false;
    }
    try {
      data = FileUtil.load(path, secKey);
    } catch (e) {
      Log.error(m.file.openFailedErr("$short.sp"), error: e);
      _alert(m.file.openErr,
          m.file.openFailedErr("$short.sp") + "\n${m.pswd.checkKey}");
      return false;
    }
    return true;
  }

  void _loadAndUnlock() async {
    if (!Util.isInCurrentDir(choosed)) {
      Log.fine("${m.file.loadNew}: $choosed");
      if (_load(choosed, secKey)) {
        choosed = FileUtil.makeCopy(choosed);
        _unlock();
      }
      return;
    }
    if (currentFilename == choosed) {
      Log.fine("${m.file.loadCurrent}: $choosed");
      String password = Util.decryptPassword(secPassword, data.key, randomIdx);
      if (password == secKey) {
        _unlock(current: true);
      } else {
        _alert(m.common.error, m.pswd.pswdHint);
      }
      return;
    }
    String path = Util.getPath(choosed);
    if (_load(path, secKey)) {
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
    String f = await FilePicker.getFilePath();
    if (f == null) {
      return;
    }
    otherFile = f;
    choosed = f;
    setState(() {});
  }

  void _unlock({bool current: false}) {
    if (current) {
      AppLock.of(context).didUnlock();
      return;
    }
    currentFilename = choosed;
    randomIdx = Util.randomKey();
    secPassword = Util.encryptPassword(secKey, data.key, randomIdx);
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
