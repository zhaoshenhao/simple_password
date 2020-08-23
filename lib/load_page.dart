import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'create_page.dart';
import 'file_utility.dart';
import 'globals.dart';
import 'ui_utility.dart';
import 'utility.dart';

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Simple Password',
        theme: new ThemeData(
          primaryColor: Colors.red,
        ),
        home: new Scaffold(
          appBar: AppBar(
            title: Text("Simple Password"),
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
  static final String noneFile = "-- None --";
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
        UiUtil.headingRow("Load Password File"),
        Row(children: <Widget>[
          Expanded(child: Text('Recent')),
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
              tooltip: 'Open from other location',
              color: Colors.red,
              onPressed: () async => _openFile()),
        ]),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Main Secret Key",
              hintText: 'Enter your main secret key',
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _showPassword = !_showPassword;
                }),
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.red,
                ),
              )),
          obscureText: !_showPassword,
          onChanged: (val) => {secKey = val},
        ),
        Text(''),
        Row(children: <Widget>[
          Expanded(
              child: Text("Open in read-only mode",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          ToggleSwitch(
            initialLabelIndex: readOnly ? 0 : 1,
            minWidth: 80.0,
            cornerRadius: 10.0,
            minHeight: 25,
            activeBgColor: Colors.red,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            labels: ['On', 'Off'],
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
          children: <Widget>[
            new RaisedButton.icon(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () => _newFile(),
              label: Text('New File'),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.lock_open),
              onPressed: hasHistory ? () => _loadAndUnlock() : null,
              color: Colors.red,
              textColor: Colors.white,
              label: Text('Load File'),
            ),
          ],
        ),
      ],
    );
  }

  void _alert(String title, String message) async {
    await dialog.showOkAlertDialog(
        context: context, title: title, message: "\n" + message);
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
      _alert("File not found", "File $short.sp not found.");
      return false;
    }
    try {
      data = FileUtil.load(path, secKey);
    } catch (e) {
      Log.error("Open filed $short.sp failed.", error: e);
      _alert("Open Error",
          "Open file $short.sp failed.\nCheck main secret key and file format.");
      return false;
    }
    return true;
  }

  void _loadAndUnlock() async {
    if (!Util.isInCurrentDir(choosed)) {
      Log.fine("Load new external file: $choosed");
      if (_load(choosed, secKey)) {
        choosed = FileUtil.makeCopy(choosed);
        _unlock();
      }
      return;
    }
    if (currentFilename == choosed) {
      Log.fine("Load current file: $choosed");
      String password = Util.decryptPassword(secPassword, data.key, randomIdx);
      if (password == secKey) {
        _unlock(current: true);
      }
      return;
    }
    String path = Util.getPath(choosed);
    if (_load(path, secKey)) {
      Log.fine("Load new file: $choosed");
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
    if (currentFilename == choosed) {}
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
