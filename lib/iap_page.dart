import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/iap_utility.dart';
import 'package:simple_password/ui_utility.dart';
import 'package:simple_password/utility.dart';

class IapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(m.iap.title),
      ),
      body: new Center(
        child: new IapWidget(),
      ),
    );
  }
}

class IapWidget extends StatefulWidget {
  IapWidget({Key key}) : super(key: key);

  @override
  _IapWidgetState createState() => _IapWidgetState();
}

class _IapWidgetState extends State<IapWidget> {
  TextStyle header = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  bool verified = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: _buildRows(),
    ));
  }

  List<Widget> _buildRows() {
    List<Widget> list = List();
    list.add(ListTile(title: Text(m.iap.thankYou, style: header)));
    if (IapUtil.isPaid()) {
      list.add(ListTile(title: Text(m.iap.paid)));
      return list;
    }
    list.addAll(<Widget>[
      ListTile(title: Text(m.iap.benefits, style: header)),
      _addBulletin(m.iap.benefits1),
      _addBulletin(m.iap.benefits2),
      Divider(),
      SwitchListTile(
        title: Text(m.iap.verify),
        value: verified,
        onChanged: (bool val) => setState(() {
          verified = val;
        }),
      ),
      Divider(),
      Center(
        child: RaisedButton.icon(
            icon: Icon(Icons.payment),
            onPressed: () => verified ? _buy() : null,
            color: verified ? Colors.blue : Colors.grey,
            textColor: Colors.white,
            label: Text(m.iap.buyTitle)),
      ),
    ]);
    return list;
  }

  Widget _addBulletin(String text) {
    return Container(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.star),
            Text(' '),
            Expanded(child: Text(text, style: TextStyle(fontSize: 18)))
          ],
        ));
  }

  Future _buy() async {
    if (await UiUtil.confirm(m.iap.buyTitle, m.iap.buyConfirmMsg, context)) {
      final progress = ProgressHUD.of(context);
      progress.show();
      bool ret = await IapUtil.buy();
      Future.delayed(Duration(seconds: 2), () {
        progress.dismiss();
      });
      if (ret) {
        Util.localeChangeCallback();
        Navigator.pop(context);
      } else {
        dialog.showAlertDialog(
            context: context, title: m.common.error, message: m.iap.failed);
      }
    }
  }
}
