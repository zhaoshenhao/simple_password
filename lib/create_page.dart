import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:flutter/material.dart';

import 'data.dart';
import 'file_utility.dart';
import 'ui_utility.dart';
import 'utility.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Create Password File"),
      ),
      body: new Center(
        child: new CreatePageWidget(),
      ),
    );
  }
}

class CreatePageWidget extends StatefulWidget {
  CreatePageWidget({Key key}) : super(key: key);

  @override
  _CreatePageWidgetState createState() => _CreatePageWidgetState();
}

class _CreatePageWidgetState extends State<CreatePageWidget> {
  final _formKey = GlobalKey<FormState>();
  Data _data;
  String _secKey2;
  bool _showPassword2 = false;
  @override
  Widget build(BuildContext context) {
    _data = Util.mockData();
    BasicData _basicData = _data.basicData;
    return Form(
        key: _formKey,
        child: new ListView(padding: UiUtil.edgeInsets, children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Password file name:",
              hintText: 'A valid file name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the name of the password file.';
              }
              if (!Util.isValidFileName(value)) {
                return 'Please use [a-zA-Z0-9_-] only';
              }
              return null;
            },
            onChanged: (val) => {_basicData.name = val},
            initialValue: _basicData.name,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Main Secret Key",
                hintText: 'Enter your main secret key',
                suffixIcon: GestureDetector(
                  onTap: () => setState(() {
                    _showPassword2 = !_showPassword2;
                  }),
                  child: Icon(
                    _showPassword2 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.red,
                  ),
                )),
            obscureText: !_showPassword2,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter your main secret key.';
              }
              return null;
            },
            onChanged: (val) => {_secKey2 = val},
          ),
          Text(''),
          Center(
              child: RaisedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _create(),
            color: Colors.red,
            textColor: Colors.white,
            label: Text('Create'),
          )),
        ]));
  }

  void _alert(String title, String message) async {
    await dialog.showOkAlertDialog(
        context: context, title: title, message: "\n" + message);
  }

  void _create() {
    if (_formKey.currentState.validate()) {
      String fn = Util.getPath(_data.basicData.name);
      if (FileUtil.fileExist(fn)) {
        _alert("File exist",
            'File \"${_data.basicData.name}\" exist!\nPlease use different name.');
        return;
      }
      if (!FileUtil.save(_data, fn, _secKey2)) {
        _alert("File save error", "Save file ${_data.basicData.name} failed.");
        return;
      }
      List<String> hist = Util.getHistoryFiles();
      if (hist == null) {
        hist = List();
      }
      if (!hist.contains(_data.basicData.name)) {
        hist.insert(0, _data.basicData.name);
      }
      Util.setHistoryFiles(hist);
      Navigator.pop(context);
    }
  }
}
