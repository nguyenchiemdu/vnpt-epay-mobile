import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vnpt_epay_mobile/vpnt_epay/vnpt_epay_hepler.dart';

class PaymentBrowser extends InAppBrowser {
  final vnptEpayHelper = VnptEpayHelper();
  final Map<String, dynamic> transaction;
  final indexPath = 'assets/index.html';
  bool isFormSubmitted = false;
  final paymentBrowserOptions = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(
      hideUrlBar: true,
    ),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        clearCache: true,
        incognito: true,
      ),
    ),
  );
  PaymentBrowser({required this.transaction});
  @override
  void onLoadStart(Uri? url) {
    //TODO: handle url
    if (url.toString().startsWith('zalopay')) {
      InAppBrowser.openWithSystemBrowser(url: url!);
    }
  }

  @override
  Future onLoadStop(url) async {
    if (!isFormSubmitted) {
      isFormSubmitted = true;
      super.webViewController.evaluateJavascript(
          source: vnptEpayHelper.getJavaScriptCode(transaction));
    }
  }

  Future openPaymentBrowser() {
    return super
        .openFile(assetFilePath: indexPath, options: paymentBrowserOptions);
  }
}
