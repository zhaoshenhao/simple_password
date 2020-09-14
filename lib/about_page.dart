import 'package:flutter/material.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';
import 'package:simple_password/security_utility.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.common.about),
      ),
      body: new Center(
        child: new AbountWidget(),
      ),
    );
  }
}

class AbountWidget extends StatefulWidget {
  AbountWidget({Key key}) : super(key: key);

  @override
  _AbountWidgetState createState() => _AbountWidgetState();
}

class _AbountWidgetState extends State<AbountWidget> {
  final String copytype = IapUtil.isPaid ? m.iap.paid : m.iap.unpaid;
  int cnt = 0;

  void _omy(BuildContext context) async {
    cnt += 1;
    if (IapUtil.isPaid || cnt < 5) {
      return;
    }
    cnt = 0;
    DialogTextField f = new DialogTextField(validator: (value) {
      if (value == '') {
        return "Value is empty";
      }
      return null;
    },);
    List<String> list = await showTextInputDialog(context: context, title: "Product Key", message: "Paste your key below.", textFields: [f]);
    if (list == null || list.isEmpty) {
      return;
    }
    String deviceId = SecUtil.getDeviceID();
    String sig = list.first;
    if (SecUtil.verify(deviceId, sig)) {
      SecUtil.saveSignature(sig);
      IapUtil.init();
      Scaffold.of(context).showSnackBar(UiUtil.snackBar("Product key saved."));
    } else {
      Scaffold.of(context).showSnackBar(UiUtil.snackBar("Invalid key"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new ListView(
          padding: UiUtil.edgeInsets,
          children: _list(context),
        ),
      ),
    );
  }

  List<Widget> _list(BuildContext context) {
    List<Widget> list = List();
    list.addAll(<Widget>[
            UiUtil.headingRow(m.common.about),
            Text(''),
            Text(m.common.copyRight),
            Text(copytype),
            Text(m.common.app + ": " + m.common.appName(IapUtil.isPaid)),
            Text(m.common.developer + ": " + m.common.companyName),
            Text(m.common.version + ": " + Util.version),
            Text(''),
            UiUtil.headingRow(m.common.terms),
            Text(''),
            Text(m.about.terms),
            Text(''),
            UiUtil.headingRow(m.common.privacy),
            Text(''),
            Text(m.about.privacy),
            Text(''),]);
    if (IapUtil.isPaid) {
      return list;
    }
    list.add(SelectableText('Device Id: ' + SecUtil.getDeviceID(), onTap: () async => _omy(context),));
    list.add(Text(''));
    return list;
  }
}
