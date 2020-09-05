import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_password/data.dart';
import 'package:simple_password/drawer.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/group_page.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/pro_utility.dart';
import 'package:simple_password/save_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

class PasswordsPage extends StatefulWidget {
  @override
  createState() => new PasswordsPageState();
}

class PasswordsPageState extends State<PasswordsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  Timer _timer;
  int _start = data.securityPolicy.autoSaveInterval;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      Log.fine("Cancel auto-save timer");
      _timer.cancel();
    }
  }

  void _startTimer() {
    if (_timer != null && _timer.isActive) {
      return null;
    }
    if (!data.securityPolicy.autoSave ||
        data.securityPolicy.autoSaveInterval <= 0) {
      return;
    }
    if (changes <= 0 || readOnly) {
      return;
    }
    Log.fine("Start auto-save timer");
    const oneSec = const Duration(seconds: 1);
    _start = data.securityPolicy.autoSaveInterval;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start < 1) {
        _cancelTimer();
        _save(confirmed: true);
      } else {
        _start = _start - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _startTimer();
    return new Scaffold(
      body: _buildGroups(context),
    );
  }

  void _add() {
    if (readOnly) {
      return;
    }
    int limit = ProUtil.groupLimit();
    if (limit > 0 && data.groups.length >= limit) {
      UiUtil.alert(
          m.iap.freeVer, "${m.iap.unpaid}\n${m.iap.freeLimit}", context);
    } else {
      Group g = Util.mockGroup(data.key);
      data.groups.add(g);
      changes++;
      _groupView(g);
    }
  }

  Widget _buildGroups(BuildContext context) {
    data.groups.sort((a, b) => a.basicData.name.compareTo(b.basicData.name));
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(m.common.appName(ProUtil.isPaid())),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () => _lockApp(),
            )
          ],
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
                tooltip: readOnly
                    ? m.common.ro
                    : m.common.rw, // used by assistive technologies
                child: readOnly
                    ? new Icon(Icons.lock_outline)
                    : new Icon(Icons.lock_open),
                onPressed: () => setState(() => readOnly = !readOnly),
                heroTag: null,
              ),
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
                tooltip: m.common.save, // used by assistive technologies
                child: new Icon(Icons.save),
                onPressed: readOnly ? null : () async => _save(),
                heroTag: null,
              ),
            ]));
  }

  List<Widget> _buildRows() {
    List<Widget> list = List();
    list.add(Container(
        padding: UiUtil.edgeInsets,
        child: UiUtil.headingRow(
            "${m.common.groups} (${m.common.total}: ${data.groups.length})")));
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
          .showSnackBar(UiUtil.snackBar(m.home.grpDeleted));
      _startTimer();
      setState(() {});
    }
  }

  Slidable _getItem(int i) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: ListTile(
            title: new Text(
              data.groups[i].basicData.name,
              style: UiUtil.biggerFont,
            ),
            subtitle: Text(
              m.home.subTitle(
                  Util.dateTimeToString(data.groups[i].basicData.deltaTime),
                  data.groups[i].passwords.length),
              style: UiUtil.smallerFont,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _groupView(data.groups[i]);
            }),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: m.common.delete,
          color: readOnly
              ? UiUtil.currentTheme.disabledColor
              : UiUtil.currentTheme.accentColor,
          icon: Icons.delete,
          onTap: readOnly ? null : () async => _delete(i),
        ),
      ],
    );
  }

  void _getRequests() async {
    setState(() {});
  }

  void _groupView(Group g) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => GroupPage(g)))
        .then((value) => _getRequests());
  }

  void _lockApp() async {
    await AppLock.of(context).showLockScreen();
    setState(() {});
  }

  Future<void> _save({bool confirmed: false}) async {
    bool ret = await SaveUtil.save(_scaffoldKey.currentContext,
        useBackupPolicy: true, confirmed: confirmed);
    if (ret == null) {
      return;
    }
    if (ret) {
      _cancelTimer();
      Scaffold.of(_scaffoldKey.currentContext)
          .showSnackBar(UiUtil.snackBar(m.common.chgSaved));
      _scaffoldKey.currentState.setState(() {});
    } else {
      Scaffold.of(_scaffoldKey.currentContext)
          .showSnackBar(UiUtil.snackBar(m.common.chgSaveFailed));
    }
  }
}
