import 'dart:io' show Platform;
import 'dart:convert';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';

import 'utility.dart';
import 'i18n/i18n.dart';

class IapUtil {
  static final int minGroup = 5;
  static final int minPassword = 10;
  static final _productId = "com.syspole.simplepasswordpro";
  //static final _productId = "com.syspole.simplepassword";
  static final List<String> _products = <String>[_productId];
  static final int _checkInterval = 60 * 60 * 24 * 30 * 1000;
  static InAppPurchaseConnection _connection;
  static bool _paid = false;
  static bool _localValid = false;
  static int _lastCheck = 0;
  static Stream _purchaseUpdated;
  static ProductDetails _productDetails;
  static String lastError;
  static StreamSubscription<List<PurchaseDetails>> _subscription;

  static get isLocalValide => _localValid;
  static get isPaid => _paid;

  static bool isProductAvailable() {
    return _productDetails != null && _productDetails.id != null;
  }

  static Future init() async {
    InAppPurchaseConnection.enablePendingPurchases();
    _connection = InAppPurchaseConnection.instance;
    _purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _productDetails = await _getProductDetails();
    bool localCheck = checkLocal();
    _localValid = _isValid();
    // if local check is valid, return
    if (localCheck && _localValid) {
      _paid = true;
      return;
    }
    _paid = await checkPayment();
  }

  static int groupLimit() {
    if (isPaid) {
      return 0;
    }
    return minGroup;
  }

  static int passwordLimit() {
    if (isPaid) {
      return 0;
    }
    return minPassword;
  }

  static bool _isValid({int last: -1}) {
    if (last == -1) {
      last = _lastCheck;
    }
    if (last == 0) {
      return false;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    return (last + _checkInterval > now);
  }

  static Future<bool> iapIsAvailable() async {
    return _connection != null && await _connection.isAvailable();
  }

  static bool checkLocal() {
    if (!(Platform.isIOS || Platform.isAndroid)) {
      return true;
    }
    String s = Util.getPayment();
    _lastCheck = 0;
    if (s == null || s == "") {
      return false;
    }
    List<String> l = s.split(":");
    if (l.length != 3) {
      return false;
    }
    try {
      _lastCheck = int.parse(l[1]);
    } catch (e) {
      return false;
    }
    String h = _hash(l[1], _lastCheck);
    return (h == l[0]);
  }

  static String _hash(String s, int last) {
    String str = s + last.toString();
    var bytes = utf8.encode(str);
    return sha256.convert(bytes).toString();
  }

  static Future<bool> _setPayment(String p) async {
    _lastCheck = DateTime.now().millisecondsSinceEpoch;
    _localValid = true;
    String h = _hash(p, _lastCheck);
    String s = h + ":" + _lastCheck.toString() + ":" + p;
    return await Util.setPayment(s);
  }

  static Future<String> _getPastPurchase() async {
    QueryPurchaseDetailsResponse purchaseResponse;
    try {
      purchaseResponse = await _connection.queryPastPurchases();
      if (purchaseResponse == null && Platform.isIOS) {
        _connection.refreshPurchaseVerificationData();
        purchaseResponse = await _connection.queryPastPurchases();
      }
      if (purchaseResponse == null) {
        return null;
      }
      for (PurchaseDetails d in purchaseResponse.pastPurchases) {
        if (d.productID == _productId) {
          if (d.status == PurchaseStatus.purchased) {
            if (d.verificationData != null) {
              return d.verificationData.localVerificationData;
            }
          }
          if (d.pendingCompletePurchase) {
            BillingResultWrapper b =
                await InAppPurchaseConnection.instance.completePurchase(d);
            if (b.responseCode == BillingResponse.ok) {
              return d.verificationData.localVerificationData;
            }
          }
        }
      }
    } catch (e) {
      lastError = e.toString();
      Log.error(lastError, error: e);
    }
    return null;
  }

  static Future checkPastPurchase() async {
    _paid = await checkPayment();
  }

  static Future<bool> checkPayment() async {
    if (!(await iapIsAvailable())) {
      return false;
    }
    String s = await _getPastPurchase();
    if (s != null) {
      await _setPayment(s);
      return true;
    }
    if (_productDetails == null) {
      _productDetails = await _getProductDetails();
      if (_productDetails == null) {
        return false;
      }
    }
    return false;
  }

  static Future<ProductDetails> _getProductDetails() async {
    ProductDetailsResponse rep;
    try {
      rep = await _connection.queryProductDetails(_products.toSet());
    } catch (e) {
      lastError = m.iap.error1;
      Log.error("Get production detail failed.", error: e);
      return null;
    }
    if (rep.error != null) {
      lastError = rep.error.message;
      Log.error("Get production detail failed.", error: rep.error);
      return null;
    }
    if (rep.productDetails == null || rep.productDetails.isEmpty) {
      lastError = m.iap.error2;
      Log.error("Product list is empty");
      return null;
    }
    for (ProductDetails d in rep.productDetails) {
      if (d.id == _productId) {
        return d;
      }
    }
    return null;
  }

  static Future<bool> buy(Function listener) async {
    if (!await iapIsAvailable()) {
      lastError = m.iap.error3;
      return false;
    }
    if (_productDetails == null) {
      _productDetails = await _getProductDetails();
      if (_productDetails == null) {
        return false;
      }
    }
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _productDetails,
        applicationUserName: null,
        sandboxTesting: true);
    bool ret = await _connection.buyNonConsumable(purchaseParam: purchaseParam);
    if (!ret) {
      return ret;
    }
    if (_subscription == null) {
      _subscription = _purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList, listener);
      }, onDone: () {
        _subscription.cancel();
        _subscription = null;
      }, onError: (error) {
        _subscription.cancel();
        _subscription = null;
        Log.error("Purchase udpate error.", error: error);
        listener(-1);
      });
    }
    return ret;
  }

  static bool _verifyPurchase(PurchaseDetails d) {
    return (d.productID == _productId &&
        d.status == PurchaseStatus.purchased &&
        d.verificationData != null &&
        d.verificationData.localVerificationData != null);
  }

  static void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, Function listener) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        return;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          Log.error(
              "Purcahse status error: " +
                  purchaseDetails.error.details.toString(),
              error: purchaseDetails.error);
          listener(1);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            listener(0);
          } else {
            listener(2);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }
}
