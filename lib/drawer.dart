import 'package:flutter/material.dart';
import 'package:simple_password/about_page.dart';
import 'package:simple_password/basic_info_page.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/iap_page.dart';
import 'package:simple_password/look_feel_page.dart';
import 'package:simple_password/password_settings_page.dart';
import 'package:simple_password/save_page.dart';
import 'package:simple_password/settings_page.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:simple_password/iap_utility.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  _AppDrawerWidgetState createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildList(),
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(m.common.appName(IapUtil.isPaid),
                style: TextStyle(
                    color: UiUtil.currentTheme.buttonColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500)),
            //Text(''),
            Divider(color: UiUtil.currentTheme.buttonColor),
            Text(
              "${m.common.file}: $currentFilename${Util.ext}   (${m.common.ro}: ${readOnly ? m.common.on : m.common.off})",
              style: TextStyle(
                  fontSize: 14, color: UiUtil.currentTheme.buttonColor),
            ),
            Text('${m.common.unsaved}: ' + changes.toString(),
                style: TextStyle(
                    color: UiUtil.currentTheme.buttonColor, fontSize: 14)),
            UiUtil.accessTime(data.basicData.accessTime,
                color: UiUtil.currentTheme.buttonColor),
            UiUtil.deltaTime(data.basicData.deltaTime,
                color: UiUtil.currentTheme.buttonColor),
            UiUtil.createTime(data.basicData.createTime,
                color: UiUtil.currentTheme.buttonColor),
          ]),
      decoration: BoxDecoration(color: UiUtil.currentTheme.primaryColor),
    );
  }

  List<Widget> _buildList() {
    List<Widget> list = List();
    list.add(_createHeader());
    list.addAll(<Widget>[
      ListTile(
        leading: Icon(Icons.collections_bookmark),
        title: Text(m.basic.info),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => BasicInfoPage()));
        },
      ),
      ListTile(
        leading: Icon(Icons.content_copy),
        title: Text(m.sbs.title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => SaveAndBackupPage()));
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(m.common.settings),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => BackupSettingsPage()));
        },
      ),
      ListTile(
        leading: Icon(Icons.playlist_add_check),
        title: Text(m.pp.title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => PasswordSettingsPage()));
        },
      ),
      ListTile(
        leading: Icon(Icons.translate),
        title: Text(m.common.lookFeel),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => LookFeelPage()));
        },
      ),
    ]);
    if (!IapUtil.isPaid) {
      list.addAll(<Widget>[
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text(m.iap.title),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => IapPage()));
          },
        ),
      ]);
    }
    list.addAll(<Widget>[
      Divider(),
      ListTile(
        leading: Icon(Icons.copyright),
        title: Text(m.common.about),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => AboutPage()));
        },
      ),
      ListTile(
        title: Center(
          child: Text(Util.version),
        ),
      )
    ]);
    return list;
  }
}
