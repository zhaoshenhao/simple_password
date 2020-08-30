class ProUtil {
  static final bool paid = true;
  static int minGroup = 5;
  static int minPassword = 5;

  static int groupLimit() {
    if (paid) {
      return 0;
    }
    return minGroup;
  }

  static int passwordLimit() {
    if (paid) {
      return 0;
    }
    return minPassword;
  }

  static bool isPaid() {
    return paid;
  }
}
