import 'package:flutter/material.dart';
import 'package:simple_password/about_page.dart';
import 'package:simple_password/backup_settings_page.dart';
import 'package:simple_password/basic_info_page.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/password_settings_page.dart';
import 'package:simple_password/save_page.dart';
import 'package:simple_password/security_settings_page.dart';
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
            title: Text('Basic Information'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => BasicInfoPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.content_copy),
            title: Text('Save & Backup & Share'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => SaveAndBackupPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Backup Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => BackupSettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Password Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => PasswordSettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Security Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => SecuritySettingsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.copyright),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => AboutPage()));
            },
          ),
          ListTile(
            title: Center(
              child: Text(version),
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
            Text("Simple Password",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500)),
            Text(''),
            Text("Read only: ${readOnly ? 'On' : 'Off'}",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Unsaved changes: ' + changes.toString(),
                style: TextStyle(color: Colors.white)),
            Text(
              "File: $currentFilename${Util.ext}",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
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
