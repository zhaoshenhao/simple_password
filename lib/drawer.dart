import 'package:flutter/material.dart';
import 'package:simple_password/about_page.dart';
import 'package:simple_password/basic_info_page.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/password_settings_page.dart';
import 'package:simple_password/save_page.dart';
import 'package:simple_password/settings_page.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

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
        children: <Widget>[
          _createHeader(),
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
            leading: Icon(Icons.settings),
            title: Text(m.pp.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => PasswordSettingsPage()));
            },
          ),
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
              child: Text(m.common.appVer),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(m.common.appName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500)),
            //Text(''),
            Divider(color: Colors.white),
            Text(
              "${m.common.file}: $currentFilename${Util.ext}   (${m.common.ro}: ${readOnly ? m.common.on : m.common.off})",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text('${m.common.unsaved}: ' + changes.toString(),
                style: TextStyle(color: Colors.white, fontSize: 14)),
            UiUtil.accessTime(data.basicData.accessTime, color: Colors.white70),
            UiUtil.deltaTime(data.basicData.deltaTime, color: Colors.white70),
            UiUtil.createTime(data.basicData.createTime, color: Colors.white70),
          ]),
      decoration: BoxDecoration(
        color: Colors.red,
      ),
    );
  }
}
