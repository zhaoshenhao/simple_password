library simple_password.i18n;

import 'message.i18n.dart';
import 'message_zh.i18n.dart';

Message m;

void loadMessage(lang) {
  if (lang == "zh") {
    m = Message_zh();
  } else {
    m = Message();
  }
}
