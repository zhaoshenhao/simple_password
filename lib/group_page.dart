import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/password_page.dart';
import 'package:simple_password/save_utility.dart';
import 'package:simple_password/pro_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

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
        title: Text(m.group.detail),
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
    return new Scaffold(
        body: Form(
          key: _formKey,
          child: new ListView(
            children: _getList(),
          ),
        ),
        floatingActionButton: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FloatingActionButton(
                backgroundColor:
                    readOnly ? UiUtil.currentTheme.disabledColor : null,
                tooltip: m.common.add, // used by assistive technologies
                child: new Icon(Icons.add),
                onPressed: readOnly ? null : () => setState(() => _add()),
                heroTag: null,
              ),
              new FloatingActionButton(
                backgroundColor:
                    readOnly ? UiUtil.currentTheme.disabledColor : null,
                tooltip: m.common.confirm, // used by assistive technologies
                child: new Icon(Icons.check_circle_outline),
                onPressed: readOnly ? null : () => _confirm(),
                heroTag: null,
              ),
            ]));
  }

  void _add() {
    if (readOnly) {
      return;
    }
    int limit = ProUtil.groupLimit();
    if (limit > 0 && _group.passwords.length >= limit) {
      UiUtil.alert(
          m.iap.freeVer, "${m.iap.unpaid}\n${m.iap.freeLimit}", context);
    } else {
      Password p = Util.mockPassword(data.key);
      _group.passwords.add(p);
      _passwordView(_group.passwords.length - 1);
      changes++;
      _group.basicData.deltaTime = DateTime.now();
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.group.pswdCreated));
    }
  }

  Slidable _buildPasswordRow(int i) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        //color: Colors.white,
        child: ListTile(
            title: new Text(
              _group.passwords[i].basicData.name,
              style: UiUtil.biggerFont,
            ),
            subtitle: Text(
              '${m.common.lastDelta}: ${Util.dateTimeToString(_group.passwords[i].basicData.deltaTime)}',
              style: UiUtil.smallerFont,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _passwordView(i);
            }),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: m.common.delete,
          color: readOnly ? UiUtil.currentTheme.disabledColor : null,
          icon: Icons.delete,
          onTap: readOnly ? null : () async => _delete(i),
        ),
      ],
    );
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      _group.basicData.deltaTime = DateTime.now();
      data.groups[gindex] = _group.clone();
      UiUtil.confirmAll(context);
    }
  }

  Future<void> _delete(int i) async {
    if (readOnly) {
      return;
    }
    if (await SaveUtil.delete(context, i, _group.passwords)) {
      Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.group.pswdCreated));
      setState(() {});
    }
  }

  List<Widget> _getGroupFields() {
    return <Widget>[
      Container(
          padding: UiUtil.edgeInsets,
          child: TextFormField(
            cursorColor: UiUtil.currentTheme.accentColor,
            readOnly: readOnly,
            decoration: InputDecoration(
              labelText: m.common.notes,
            ),
            onChanged: (val) => setState(() => _group.basicData.notes = val),
            initialValue: _group.basicData.notes,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          )),
      Text(''),
      Container(
          padding: UiUtil.edgeInsets2,
          child: UiUtil.accessTime(_group.basicData.accessTime)),
      Container(
          padding: UiUtil.edgeInsets2,
          child: UiUtil.deltaTime(_group.basicData.deltaTime)),
      Container(
          padding: UiUtil.edgeInsets2,
          child: UiUtil.createTime(_group.basicData.createTime)),
    ];
  }

  List<Widget> _getList() {
    List<Widget> list = new List();
    list.add(Container(
        padding: UiUtil.edgeInsets,
        child: TextFormField(
          cursorColor: UiUtil.currentTheme.accentColor,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: m.group.name,
            hintText: m.common.notEmpty,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return m.group.hint;
            }
            return null;
          },
          onChanged: (val) => setState(() => _group.basicData.name = val),
          initialValue: _group.basicData.name,
        )));
    list.add(Container(
        padding: UiUtil.edgeInsets2,
        child: UiUtil.headingRow(m.common.passwords)));
    _group.passwords
        .sort((a, b) => a.basicData.name.compareTo(b.basicData.name));
    for (int i = 0; i < _group.passwords.length; i++) {
      list.add(_buildPasswordRow(i));
    }
    list.addAll(_getGroupFields());
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
