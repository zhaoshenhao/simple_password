import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/password_page.dart';
import 'package:simple_password/save_utility.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

Group _group;
Group _og;

class GroupPage extends StatelessWidget {
  GroupPage(Group og) {
    _og = og;
    _group = og.clone();
    _group.basicData.accessTime = DateTime.now();
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
    int limit = IapUtil.passwordLimit();
    if (limit > 0 && _group.passwords.length >= limit) {
      UiUtil.alert(
          m.iap.freeVer, "${m.iap.unpaid}\n${m.iap.freeLimit}", context);
    } else {
      Password p = Util.mockPassword(data.key);
      _group.passwords.add(p);
      _passwordView(p);
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
              _passwordView(_group.passwords[i]);
            }),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: m.common.move,
          color: readOnly
              ? UiUtil.currentTheme.disabledColor
              : UiUtil.currentTheme.accentColor,
          icon: Icons.code,
          onTap: readOnly ? null : () async => _op(i),
        ),
        IconSlideAction(
          caption: m.common.delete,
          color: readOnly
              ? UiUtil.currentTheme.disabledColor
              : UiUtil.currentTheme.accentColor,
          icon: Icons.delete,
          onTap: readOnly ? null : () async => _delete(i),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: m.common.password,
          color: UiUtil.currentTheme.accentColor,
          icon: Icons.content_copy,
          onTap: readOnly ? null : () async => _copyPswd(i),
        ),
        IconSlideAction(
          caption: m.common.un,
          color: UiUtil.currentTheme.accentColor,
          icon: Icons.content_copy,
          onTap: readOnly ? null : () async => _copyUn(i),
        ),
        IconSlideAction(
          caption: m.common.url,
          color: UiUtil.currentTheme.accentColor,
          icon: Icons.content_copy,
          onTap: readOnly ? null : () async => _copyUrl(i),
        ),
      ],
    );
  }

  List<AlertDialogAction<int>> _getActions() {
    List<AlertDialogAction<int>> list = List();
    if (data == null || data.groups == null || data.groups.length < 1) {
      return list;
    }
    for (int n = 0; n < data.groups.length; n++) {
      list.add(new AlertDialogAction(
        key: n,
        label: data.groups[n].basicData.name +
            "(" +
            data.groups[n].passwords.length.toString() +
            ")",
      ));
    }
    return list;
  }

  void _op(int i) async {
    int gi = await showConfirmationDialog<int>(
        context: context,
        title: m.common.move,
        message: m.pswd.movePswd,
        okLabel: m.common.confirm,
        cancelLabel: m.common.cancel,
        style: AdaptiveStyle.material,
        actions: _getActions());
    int len = data.groups.length;
    if (gi == null || gi < 0 && gi >= len) {
      return;
    }
    DateTime d = _group.basicData.createTime;
    Group g = data.groups[gi];
    if (g.basicData.createTime == d) {
      // Copy
      Password p = _group.passwords[i].clone();
      p.basicData.name = p.basicData.name + "-copy";
      _group.passwords.add(p);
    } else {
      // Move
      Password p = _group.passwords.removeAt(i);
      g.passwords.add(p);
    }
    _change();
    setState(() {});
  }

  void _copyPswd(int i) {
    Password _password = _group.passwords[i];
    String tmp = _password.password;
    String p = Util.decryptPassword(tmp, data.key, _password.key);
    Clipboard.setData(ClipboardData(text: p));
    Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.pswd.pswdCopied));
  }

  void _copyUn(int i) {
    Clipboard.setData(ClipboardData(text: _group.passwords[i].username));
    Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.pswd.unCopied));
  }

  void _copyUrl(int i) {
    Clipboard.setData(ClipboardData(text: _group.passwords[i].url));
    Scaffold.of(context).showSnackBar(UiUtil.snackBar(m.pswd.urlCopied));
  }

  void _change() {
    _group.basicData.deltaTime = DateTime.now();
    _og.copyFrom(_group);
    UiUtil.makeChange(context);
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      _change();
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
        child: UiUtil.headingRow(
            "${m.common.passwords} (${m.common.total}: ${_group.passwords.length})")));
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

  void _passwordView(Password p) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => OnePasswordPage(p, _group, _og)))
        .then((value) => _getRequests());
  }
}
