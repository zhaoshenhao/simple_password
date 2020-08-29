class IapUtil {
  static bool paid = false;
  static bool isPaid() {
    return paid;
  }

  static Future<bool> buy() async {
    paid = true;
    print(paid);
    return paid;
  }
}
