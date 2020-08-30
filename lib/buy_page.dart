import 'package:flutter/material.dart';
import 'package:simple_password/i18n/i18n.dart';
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
    list.addAll(<Widget>[
      ListTile(title: Text(m.iap.benefits, style: header)),
      _addBulletin(m.iap.benefits1),
      _addBulletin(m.iap.benefits2),
      Divider(),
      Center(
        child: RaisedButton.icon(
            icon: Icon(Icons.payment),
            onPressed: () {
              _buy();
            },
            color: UiUtil.priColor,
            textColor: Colors.white,
            label: Text(m.iap.buyTitle)),
      ),
      Divider(),
      ListTile(title: Text(m.iap.warn, style: header2)),
      _addBulletin(m.iap.warn1),
      _addBulletin2(m.iap.warn2, 1),
      _addBulletin2(m.iap.warn3, 2),
      _addBulletin2(m.iap.warn4, 3),
      _addBulletin2(m.iap.warn5, 4),
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

  void _buy() {
    Log.fine("Open app store");
    //TODO
  }
}
