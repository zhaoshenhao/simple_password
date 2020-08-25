import 'package:flutter/material.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/ui_utility.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          m.common.about,
        ),
      ),
      body: new Center(
        child: new ListView(
          padding: UiUtil.edgeInsets,
          children: <Widget>[
            UiUtil.headingRow(m.common.about),
            Text(''),
            Text(m.common.copyRight),
            Text(m.common.app + ": " + m.common.appName),
            Text(m.common.developer + ": " + m.common.companyName),
            Text(m.common.version + ": " + m.common.appVer),
            Text(''),
            UiUtil.headingRow(m.common.terms),
            Text(''),
            Text(m.about.terms),
            Text(''),
            UiUtil.headingRow(m.common.privacy),
            Text(''),
            Text(m.about.privacy),
          ],
        ),
      ),
    );
  }
}
