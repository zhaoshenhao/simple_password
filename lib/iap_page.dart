import 'package:flutter/material.dart';
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
  final TextStyle header2 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red);
  bool verified = false;
  bool _buying = false;
  bool _prodOk = true;
  bool _connOk = true;

  void buyListener(int code) {
    setState(() {
      _buying = false;
    });

    if (code == 0) {
      UiUtil.alert(m.iap.thankYouTitle, m.iap.succ, context);
      Util.localeChangeCallback();
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

  void _checkPastPurcahse(bool val) async {
    verified = val;
    if (!verified) {
      setState(() {});
      return;
    }
    await IapUtil.checkPastPurchase();
    if (!IapUtil.isPaid) {
      _connOk = await IapUtil.iapIsAvailable();
      _prodOk = IapUtil.isProductAvailable();
      setState(() {});
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
    if (IapUtil.isPaid) {
      list.add(ListTile(title: Text(m.iap.paid)));
      return list;
    }
    list.addAll(<Widget>[
      ListTile(title: Text(m.iap.benefits, style: header)),
      _addBulletin(m.iap.benefits1),
      _addBulletin(m.iap.benefits2),
      _addBulletin(m.iap.benefits3),
      Divider(),
      SwitchListTile(
        title: Text(m.iap.verify),
        value: verified,
        onChanged: (bool val) async => _checkPastPurcahse(val),
      ),
      Divider(),
      Center(
        child: RaisedButton.icon(
            icon: Icon(Icons.payment),
            onPressed: (verified && _prodOk && _connOk)
                ? () {
                    _buy();
                  }
                : null,
            color: verified
                ? UiUtil.currentTheme.primaryColor
                : UiUtil.currentTheme.disabledColor,
            label: Text(m.iap.buyTitle)),
      ),
    ]);
    if (_prodOk && _connOk) {
      return list;
    }
    list.add(Divider());
    list.add(ListTile(title: Text(m.common.error, style: header)));
    if (!_connOk) {
      list.add(_addBulletin(m.iap.error3));
    }
    if (!_prodOk) {
      list.add(_addBulletin(m.iap.error2));
    }
    list.add(_addBulletin(m.iap.failed));
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
    if (!ret) {
      return;
    }
    ret = await IapUtil.buy(buyListener);
    if (ret) {
      setState(() {
        _buying = true;
      });
    } else {
      if (IapUtil.isPaid) {
        setState(() {});
      } else {
        UiUtil.alert(m.common.error, m.iap.buyError1, context);
      }
    }
  }
}
