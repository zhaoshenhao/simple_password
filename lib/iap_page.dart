import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart' as dialog;
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  final TextStyle header = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  bool verified = false;
  bool _buying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
            inAsyncCall: _buying,
            opacity: 0.6,
            child: new ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: _buildRows(),
            )));
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
          print("call verified");
          verified = val;
        }),
      ),
      Divider(),
      Center(
        child: RaisedButton.icon(
            icon: Icon(Icons.payment),
            onPressed: () {
              print("press");
              _buy();
            },
            color: verified ? UiUtil.priColor : UiUtil.disColor,
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
    print("buy");
    bool ret =
        await UiUtil.confirm(m.iap.buyTitle, m.iap.buyConfirmMsg, context);
    if (ret) {
      setState(() {
        _buying = true;
      });
      await Future.delayed(Duration(seconds: 5), () {
        print("done");
      });
      ret = await IapUtil.buy();
      setState(() {
        _buying = false;
      });
      if (ret) {
        dialog.showAlertDialog(
            context: context,
            title: m.iap.thankYouTitle,
            message: m.iap.succ,
            style: dialog.AdaptiveStyle.material);
        Util.localeChangeCallback();
        Navigator.pop(context);
      } else {
        dialog.showAlertDialog(
            context: context,
            title: m.common.error,
            message: m.iap.failed,
            style: dialog.AdaptiveStyle.material);
      }
    }
  }
}
