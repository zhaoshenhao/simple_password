import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

import 'home_page.dart';
import 'load_page.dart';
import 'utility.dart';

//void main() => runApp(SimplePassword());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Util.init();
  runApp(new AppLock(
    builder: (args) => SimplePassword(),
    lockScreen: LoadPage(),
    enabled: true,
  ));
}

class SimplePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Password',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: new PasswordsPage(),
    );
  }
}
