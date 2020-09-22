import 'dart:async';
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_password/home_page.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/load_page.dart';
import 'package:simple_password/local_auth_utility.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/security_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

//void main() => runApp(SimplePassword());
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  void _complete() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new AppLock(
              builder: (args) => SimplePassword(),
              lockScreen: LoadPage(),
              enabled: true,
            )));
  }

  void _start() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      LocalAuthUtil.init()
          .then((value) => SecUtil.init())
          .then((value) => IapUtil.init())
          .whenComplete(() => _complete());
      _timer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/512x512-66-rounded.png', width: 80, height: 80),
          Loading(
              indicator: BallPulseIndicator(), size: 50.0, color: Colors.blue),
        ],
      )),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Util.init();
  await UiUtil.initTheme();
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["syspole1@gmail.com"])
  ]);
  Catcher(
      new MaterialApp(
        home: SplashScreen(),
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
