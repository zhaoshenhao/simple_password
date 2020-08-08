import 'package:flutter/material.dart';

import 'data.dart';
import 'globals.dart';
import 'password_page.dart';
import 'ui_utility.dart';
import 'utility.dart';

int gindex;
Group _group;

class GroupPage extends StatelessWidget {
  GroupPage(int i) {
    gindex = i;
    Group g = data.groups[i];
    g.basicData.accessTime = DateTime.now();
    _group = g.clone();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Group Detail"),
      ),
      body: new Center(
        child: new GroupWidget(),
      ),
    );
  }
}

class GroupWidget extends StatefulWidget {
  GroupWidget({Key key}) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: _getList(),
      ),
    );
  }

  Widget _buildPasswordRow(int i) {
    return new Card(
        child: new ListTile(
      title: new Text(
        _group.passwords[i].basicData.name,
        style: UiUtil.biggerFont,
      ),
      subtitle: Text(
          'Last update: ${Util.dateTimeToString(_group.passwords[i].basicData.deltaTime)}',
          style: UiUtil.smallerFont),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        _passwordView(i);
      },
    ));
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      _group.basicData.deltaTime = DateTime.now();
      data.groups[gindex] = _group.clone();
      UiUtil.confirmAll(context);
    }
  }

  List<Widget> _getGroupFields() {
    return <Widget>[
      TextFormField(
        readOnly: readOnly,
        decoration: const InputDecoration(
          labelText: 'Notes',
        ),
        onChanged: (val) => setState(() => _group.basicData.notes = val),
        initialValue: _group.basicData.notes,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
      ),
      Text(''),
      UiUtil.accessTime(_group.basicData.accessTime),
      UiUtil.deltaTime(_group.basicData.deltaTime),
      UiUtil.createTime(_group.basicData.createTime),
    ];
  }

  List<Widget> _getList() {
    List<Widget> list = new List();
    list.add(TextFormField(
      readOnly: readOnly,
      decoration: const InputDecoration(
        labelText: "Group name",
        hintText: 'Enter something',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the group name.';
        }
        return null;
      },
      onChanged: (val) => setState(() => _group.basicData.name = val),
      initialValue: _group.basicData.name,
    ));
    list.add(Text(""));
    list.add(UiUtil.headingRow("Passwords"));
    for (int i = 0; i < _group.passwords.length; i++) {
      list.add(_buildPasswordRow(i));
    }
    list.addAll(_getGroupFields());
    list.add(UiUtil.confirmButton(_confirm));
    return list;
  }

  _getRequests() async {
    setState(() {});
  }

  void _passwordView(int i) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                OnePasswordPage(i, gindex, _group)))
        .then((value) => _getRequests());
  }
}
