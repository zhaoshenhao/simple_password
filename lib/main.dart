import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_password/home_page.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/load_page.dart';
import 'package:simple_password/local_auth_utility.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

//void main() => runApp(SimplePassword());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Util.init();
  await UiUtil.initTheme();
  await LocalAuthUtil.init();
  await IapUtil.init();
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["syspole1@gmail.com"])
  ]);
  Catcher(
      new AppLock(
        builder: (args) => SimplePassword(),
        lockScreen: LoadPage(),
        enabled: true,
      ),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
}

class SimplePassword extends StatefulWidget {
  @override
  createState() => new SimplePasswordState();
}

class SimplePasswordState extends State<SimplePassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Catcher.navigatorKey,
      title: m.common.appName(IapUtil.isPaid),
      theme: UiUtil.currentTheme,
      home: new PasswordsPage(),
      locale: Util.locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', null),
        const Locale('fr', null),
        const Locale('zh', null),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Util.localeChangeCallback = onLocaleChange;
  }

  onLocaleChange() {
    setState(() {});
  }
}
