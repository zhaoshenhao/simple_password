import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('fr', 'FR'),
        const Locale('it', 'IT'),
        const Locale('de', 'DE'),
        const Locale('es', 'ES'),
        const Locale('ru', 'RU'),
        const Locale('pt', 'PT'),
        const Locale('zh', 'CN'),
        const Locale('ja', 'JP'),
        const Locale('ko', 'KR'),
        // ... other locales the app supports
      ],
    );
  }
}
