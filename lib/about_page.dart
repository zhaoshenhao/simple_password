import 'package:flutter/material.dart';

import 'globals.dart';
import 'ui_utility.dart';

final String author = "Compusky Inc.";
final String description = "";
final String copyRight = "Copyright © 2002-2020 CompuSky Inc.";
final String terms = "Simple Password term of use";
final String privacy = "Privacy";

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
        ),
      ),
      body: new Center(
        child: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            UiUtil.headingRow("About"),
            Text(''),
            Text(copyRight),
            Text('Application: Simple Password'),
            Text('Author: ' + author),
            Text('Version: ' + version),
            Text(''),
            UiUtil.headingRow("Term of Use"),
            Text(''),
            Text(terms),
            Text(''),
            UiUtil.headingRow("Privacy Policy"),
            Text(''),
            Text(privacy),
          ],
        ),
      ),
    );
  }
}
