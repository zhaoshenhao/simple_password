import 'package:flutter/material.dart';
import 'globals.dart';
import 'drawer.dart';
import 'group_page.dart';
import 'ui_utility.dart';
import 'utility.dart';

class PasswordsPage extends StatefulWidget {
  @override
  createState() => new PasswordsPageState();
}

class PasswordsPageState extends State<PasswordsPage> {
  Widget _buildGroups() {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Simple Password"),
        ),
        drawer: AppDrawer(),
        body: new ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: data.groups.length,
            itemBuilder: (context, i) {
              return _buildRow(i);
            }),
        floatingActionButton: new FloatingActionButton(
          tooltip: 'Add', // used by assistive technologies
          child: new Icon(Icons.add),
          onPressed: () {
            print("Add something");
          },
        ));
  }

  Widget _buildRow(int i) {
    return new Card(
        child: new ListTile(
      title: new Text(
        data.groups[i].basicData.name,
        style: UiUtil.biggerFont,
      ),
      subtitle: Text(
        "Last update: ${Util.dateTimeToString(data.groups[i].basicData.deltaTime)}. Passwords: ${data.groups[i].passwords.length}",
        style: UiUtil.smallerFont,
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        _groupView(i);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildGroups(),
    );
  }

  void _groupView(int i) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => GroupPage(i)))
        .then((value) => _getRequests());
  }

  _getRequests() async {
    setState(() {});
  }
}
