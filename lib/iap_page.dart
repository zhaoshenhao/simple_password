import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:simple_password/i18n/i18n.dart';
import 'package:simple_password/pro_utility.dart';
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
  final TextStyle header2 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red);
  bool verified = false;
  bool _buying = false;

  void buyListener(int code) {
    if (code == 0) {
      UiUtil.alert(m.iap.thankYouTitle, m.iap.succ, context);
      Util.localeChangeCallback();
      Navigator.pop(context);
    } else {
      String msg;
      if (code == 1) {
        msg = m.iap.buyError1;
      } else if (code == 2) {
        msg = m.iap.buyError2;
      } else if (code == -1) {
        msg = m.iap.buyError3;
      }
      UiUtil.alert(m.common.error, msg, context);
    }
  }

  @override
  @protected
  void initState() {
    checkPastPurcahse();
    super.initState();
  }

  void checkPastPurcahse() {
    if (!ProUtil.isPaid) {
      ProUtil.checkPastPurchase();
    }
  }

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
    if (ProUtil.isPaid) {
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
            onPressed: () {
              _buy();
            },
            color: verified
                ? UiUtil.currentTheme.primaryColor
                : UiUtil.currentTheme.disabledColor,
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
    bool ret =
        await UiUtil.confirm(m.iap.buyTitle, m.iap.buyConfirmMsg, context);
    if (ret) {
      setState(() {
        _buying = true;
      });
      ret = await ProUtil.buy(buyListener);
      if (ret) {
        setState(() {
          _buying = false;
        });
      } else {
        UiUtil.alert(m.common.error, m.iap.error3, context);
      }
    }
  }

  Widget _addBulletin2(String text, int i) {
    return Container(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: Text("$i"),
              radius: 12,
            ),
            Text(' '),
            Expanded(child: Text(text, style: TextStyle(fontSize: 18)))
          ],
        ));
  }
}
