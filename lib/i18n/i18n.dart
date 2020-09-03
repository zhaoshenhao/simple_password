library simple_password.i18n;

import 'package:simple_password/i18n/message.i18n.dart';
import 'package:simple_password/i18n/message_fr.i18n.dart';
import 'package:simple_password/i18n/message_zh.i18n.dart';

Message m;

void loadMessage(lang) {
  if (lang == "zh") {
    m = Message_zh();
  } else if (lang == "fr") {
    m = Message_fr();
  } else {
    m = Message();
  }
}
