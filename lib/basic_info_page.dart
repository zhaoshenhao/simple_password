import 'package:flutter/material.dart';
import 'globals.dart';
import 'ui_utility.dart';
import 'data.dart';

class BasicInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Basic Information"),
      ),
      body: new Center(
        child: new BasicInfoWidget(),
      ),
    );
  }
}

class BasicInfoWidget extends StatefulWidget {
  BasicInfoWidget({Key key}) : super(key: key);

  @override
  _BasicInfoWidgetState createState() => _BasicInfoWidgetState();
}

class _BasicInfoWidgetState extends State<BasicInfoWidget> {
  final _formKey = GlobalKey<FormState>();
  BasicData _basicData = data.basicData.clone();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Password collection name:",
              hintText: 'Please enter something',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the name of the password collection.';
              }
              return null;
            },
            onChanged: (val) => setState(() => _basicData.name = val),
            initialValue: _basicData.name,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
            onChanged: (val) => setState(() => _basicData.notes = val),
            initialValue: _basicData.notes,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          Text(''),
          UiUtil.accessTime(_basicData.accessTime),
          UiUtil.deltaTime(_basicData.deltaTime),
          UiUtil.createTime(_basicData.createTime),
          UiUtil.confirmButton(_confirm),
        ],
      ),
    );
  }

  void _confirm() {
    if (_formKey.currentState.validate()) {
      data.basicData = _basicData.clone();
      UiUtil.confirmAll(context);
    }
  }
}
