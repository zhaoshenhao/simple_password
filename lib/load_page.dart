import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

import 'globals.dart';
import 'ui_utility.dart';
import 'utility.dart';

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Load Password File",
        ),
      ),
      body: new Center(
        child: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text("Click to unlock"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: new Center(
                  child: new RaisedButton(
                onPressed: () => _unlock(context),
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Confirm'),
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _unlock(context) {
    AppLock.of(context).didUnlock();
  }
}
