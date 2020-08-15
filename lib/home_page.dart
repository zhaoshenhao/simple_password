import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'data.dart';
import 'drawer.dart';
import 'globals.dart';
import 'group_page.dart';
import 'save_utility.dart';
import 'ui_utility.dart';
import 'utility.dart';

class PasswordsPage extends StatefulWidget {
  @override
  createState() => new PasswordsPageState();
}

class PasswordsPageState extends State<PasswordsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  //List<Group> _groups;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildGroups(context),
    );
  }

  void _add() {
    if (readOnly) {
      return;
    }
    Group g = Util.mockGroup(data.key);
    data.groups.add(g);
    changes++;
    _groupView(data.groups.length - 1);
    Scaffold.of(_scaffoldKey.currentContext)
        .showSnackBar(UiUtil.snackBar("New group created"));
  }

  Widget _buildGroups(BuildContext context) {
    data.groups.sort((a, b) => a.basicData.name.compareTo(b.basicData.name));
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Simple Password"),
        ),
        drawer: AppDrawer(),
        body: new ListView(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          children: _buildRows(),
        ),
        floatingActionButton: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FloatingActionButton(
                backgroundColor: readOnly ? Colors.blue : Colors.red,
                tooltip: readOnly
                    ? 'ReadOnly'
                    : "ReadWrite", // used by assistive technologies
                child: readOnly
                    ? new Icon(Icons.lock_outline)
                    : new Icon(Icons.lock_open),
                onPressed: () => setState(() => readOnly = !readOnly),
                heroTag: null,
              ),
              new FloatingActionButton(
                backgroundColor: readOnly ? Colors.grey : Colors.blue,
                tooltip: 'Add', // used by assistive technologies
                child: new Icon(Icons.add),
                onPressed: readOnly ? null : () => setState(() => _add()),
                heroTag: null,
              ),
              new FloatingActionButton(
                backgroundColor: readOnly ? Colors.grey : Colors.red,
                tooltip: 'Save', // used by assistive technologies
                child: new Icon(Icons.save),
                onPressed: readOnly ? null : () async => _save(),
                heroTag: null,
              ),
            ]));
  }

  List<Widget> _buildRows() {
    List<Widget> list = List();
    list.add(Container(
        padding: UiUtil.edgeInsets, child: UiUtil.headingRow("Groups")));
    for (int i = 0; i < data.groups.length; i++) {
      list.add(_getItem(i));
    }
    return list;
  }

  Future<void> _delete(int i) async {
    if (readOnly) {
      return;
    }
    if (await SaveUtil.delete(_scaffoldKey.currentContext, i, data.groups)) {
      Scaffold.of(_scaffoldKey.currentContext)
          .showSnackBar(UiUtil.snackBar("Group deleted."));
      setState(() {});
    }
  }

  Slidable _getItem(int i) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
            title: new Text(
              data.groups[i].basicData.name,
              style: UiUtil.biggerFont,
            ),
            subtitle: Text(
              "Last update: ${Util.dateTimeToString(data.groups[i].basicData.deltaTime)}. Passwords: ${data.groups[i].passwords.length}",
              style: UiUtil.smallerFont,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _groupView(i);
            }),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: readOnly ? Colors.grey : Colors.red,
          icon: Icons.delete,
          onTap: readOnly ? null : () async => _delete(i),
        ),
      ],
    );
  }

  void _getRequests() async {
    setState(() {});
  }

  void _groupView(int i) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => GroupPage(i)))
        .then((value) => _getRequests());
  }

  Future<void> _save() async {
    bool ret = await SaveUtil.save(_scaffoldKey.currentContext);
    if (ret == null) {
      return;
    }
    if (ret) {
      Scaffold.of(_scaffoldKey.currentContext)
          .showSnackBar(UiUtil.snackBar("Changes saved"));
      _scaffoldKey.currentState.setState(() {});
    } else {
      Scaffold.of(_scaffoldKey.currentContext)
          .showSnackBar(UiUtil.snackBar("Saving changes failed."));
    }
  }
}
