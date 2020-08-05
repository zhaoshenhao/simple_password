import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(SimplePassword());

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
