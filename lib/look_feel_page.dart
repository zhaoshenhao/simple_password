import 'package:flutter/material.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

class LookFeelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.common.settings),
      ),
      body: new Center(
        child: new LookFeelWidget(),
      ),
    );
  }
}

class LookFeelWidget extends StatefulWidget {
  LookFeelWidget({Key key}) : super(key: key);

  @override
  _LookFeelWidgetState createState() => _LookFeelWidgetState();
}

class _LookFeelWidgetState extends State<LookFeelWidget> {
  final _formKey = GlobalKey<FormState>();
  String lang = Util.locale.languageCode;
  String theme = UiUtil.currentThemeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: new ListView(
            padding: UiUtil.edgeInsets,
            children: <Widget>[
              UiUtil.headingRow(m.common.lookFeel),
              Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                  child: Row(children: <Widget>[
                    Text(m.settings.lang),
                    Text(":  "),
                    DropdownButton<String>(
                        value: lang,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            lang = newValue;
                          });
                        },
                        items: _dropdownList()),
                  ])),
              Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                  child: Row(children: <Widget>[
                    Text(m.settings.theme),
                    Text(":  "),
                    DropdownButton<String>(
                        value: theme,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            theme = newValue;
                          });
                        },
                        items: _dropdownList2()),
                  ])),
            ],
          ),
        ),
        floatingActionButton: UiUtil.confirmButton(_confirm));
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      String lang2 = Util.locale.languageCode;
      String theme2 = UiUtil.currentThemeName;
      bool hasChange = false;
      if (lang != lang2) {
        Util.locale = Locale(lang, '');
        hasChange = true;
        Util.setLanguage(lang);
      }
      if (theme != theme2) {
        hasChange = true;
        UiUtil.setTheme(theme);
      }
      if (hasChange) {
        Util.localeChangeCallback();
      }
    }
  }

  List<DropdownMenuItem<String>> _dropdownList() {
    List<DropdownMenuItem<String>> list = List();
    list.add(DropdownMenuItem<String>(value: 'en', child: Text('English')));
    list.add(DropdownMenuItem<String>(value: 'fr', child: Text('Français')));
    list.add(DropdownMenuItem<String>(value: 'zh', child: Text('中文')));
    return list;
  }

  List<DropdownMenuItem<String>> _dropdownList2() {
    List<DropdownMenuItem<String>> list = List();
    list.add(DropdownMenuItem<String>(
        value: 'blue',
        child: Text(
          ' Blue ',
          style: TextStyle(
              backgroundColor: Colors.blue,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )));
    list.add(DropdownMenuItem<String>(
        value: 'teal',
        child: Text(
          ' Teal ',
          style: TextStyle(
              backgroundColor: Colors.teal,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )));
    list.add(DropdownMenuItem<String>(
        value: 'indigo',
        child: Text(
          ' Indigo ',
          style: TextStyle(
              backgroundColor: Colors.indigo,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )));
    list.add(DropdownMenuItem<String>(
        value: 'red',
        child: Text(
          ' Red ',
          style: TextStyle(
              backgroundColor: Colors.red,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )));
    list.add(DropdownMenuItem<String>(
        value: 'dark',
        child: Text(
          ' Dark ',
          style: TextStyle(
              backgroundColor: Colors.black,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )));
    return list;
  }
}
