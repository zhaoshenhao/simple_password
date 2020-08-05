import 'package:flutter/material.dart';
import 'package:simple_password/about_page.dart';
import 'package:simple_password/backup_page.dart';
import 'package:simple_password/backup_settings_page.dart';
import 'package:simple_password/basic_info_page.dart';
import 'package:simple_password/globals.dart';
import 'package:simple_password/password_settings_page.dart';
import 'package:simple_password/security_settings_page.dart';
import 'package:simple_password/sync_page.dart';
import 'package:simple_password/ui_utility.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.content_copy,
            text: 'Files & Backup',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => FilesAndBackupPage()));
            },
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.collections_bookmark,
            text: 'Basic Information',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => BasicInfoPage()));
            },
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Backup Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => BackupSettingsPage()));
            },
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Password Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => PasswordSettingsPage()));
            },
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Security Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => SecuritySettingsPage()));
            },
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.copyright,
            text: 'About',
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

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Simple Password",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500)),
            Text('\n\n'),
            Text('Unsaved changes: ' + changes.toString(),
                style: TextStyle(color: Colors.white)),
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
