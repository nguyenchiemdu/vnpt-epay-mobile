import 'dart:math';
import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:vnpt_epay_mobile/enum/country_code.dart';
import 'package:vnpt_epay_mobile/enum/currency.dart';
import 'package:vnpt_epay_mobile/enum/language.dart';
import 'package:vnpt_epay_mobile/enum/pay_option.dart';
import 'package:vnpt_epay_mobile/enum/pay_type.dart';
import 'package:vnpt_epay_mobile/enum/window_type.dart';
import 'package:vnpt_epay_mobile/models/transaction.dart';

class VnptEpayHelper {
  final String encodeKey =
      'rf8whwaejNhJiQG2bsFubSzccfRc/iRYyGUn6SPmT6y/L7A2XABbu9y4GvCoSTOTpvJykFi6b1G0crU8et2O0Q==';
  final String merId = 'EPAY000001';
  final String callBackUrl =
      'https://vnpt-epay-demo.onrender.com/callback/transactionHandle';
  final String notiUrl =
      'https://vnpt-epay-demo.onrender.com/transactionHandle';
  final String reqDomain = 'https://sandbox.megapay.vn';

  final bool isSandbox;
  VnptEpayHelper({this.isSandbox = true});
  String get vnptEpayDomain {
    if (isSandbox) {
      return 'https://sandbox.megapay.vn';
    } else {
      return 'https://pg.megapay.vn';
    }
  }

  String _mapToFormattedString(Map<String, dynamic> data) {
    List<String> formattedList = data.entries.map((entry) {
      return "['${entry.key}', '${entry.value}'],";
    }).toList();
    String formattedString = '''[
    ${formattedList.join('\n    ')}
  ]''';

    return formattedString;
  }

  String _makeRandomString() {
    var text = "";
    var possible =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    var random = Random();

    for (var i = 0; i < 6; i++) {
      text += possible[random.nextInt(possible.length)];
    }
    return text;
  }

  String generateTimeStamp(DateTime date) {
    return (date.millisecondsSinceEpoch).toString();
  }

  String _encrypt(String input) {
    var bytes = utf8.encode(input); // Encode the input string to bytes
    var digest = sha256.convert(bytes); // Calculate the hash
    return digest.toString(); // Convert the hash bytes to a string
  }

  String generateMerTrxId({required DateTime date}) {
    DateTime time = date;
    String randomStr = _makeRandomString();
    String randomMertrxid =
        '$merId${time.day.toString()}${(time.month + 1)}${time.year}${time.hour}${time.minute}${time.second}$randomStr';
    return randomMertrxid;
  }

  String generateMerchantToken(
      {required String merTrxId, required DateTime date, int amount = 2000}) {
    String timeStamp = generateTimeStamp(date);
    String createMerchantToken = '$timeStamp$merTrxId$merId$amount$encodeKey';
    String merchantToken = _encrypt(createMerchantToken);
    return merchantToken;
  }

  String generateInvoiceNo({required DateTime date}) {
    String fullDate =
        '${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}${date.millisecond}';
    String prefixStr = 'OrdNo';
    return prefixStr + fullDate;
  }

  Transaction createTransaction(
      {required String amount,
      required String goodsNm,
      required String buyerFirstNm,
      required String buyerLastNm,
      required String buyerPhone,
      required String userId,
      PayType payType = PayType.NO}) {
    Currency currency = Currency.VND;
    Language userLanguage = Language.VN;
    WindowType windowType = WindowType.mobile;
    String description = 'TNUWKCMFVW';
    PayOption payOption = PayOption.PAY_CREATE_TOKEN;
    Color windowColor = const Color(0xff0061e3);

    /// Generated Fields
    DateTime date = DateTime.now();
    String timeStamp = generateTimeStamp(date);
    String invoiceNo = generateInvoiceNo(date: date);
    String merTrxId = generateMerTrxId(date: date);
    String merchantToken = generateMerchantToken(
        merTrxId: merTrxId, date: date, amount: int.parse(amount));
    return Transaction(
      buyerCountry: CountryCode.vn,
      buyerLastNm: buyerLastNm,
      buyerFirstNm: buyerFirstNm,
      buyerPhone: buyerPhone,
      userId: userId,
      amount: int.parse(amount),
      goodsNm: goodsNm,
      callBackUrl: callBackUrl,
      notiUrl: notiUrl,
      currency: currency,
      userLanguage: userLanguage,
      windowType: windowType,
      description: description,
      payType: payType,
      payOption: payOption,
      reqDomain: reqDomain,
      windowColor: windowColor,
      payToken: '',
      merchantToken: merchantToken,
      timeStamp: timeStamp,
      merId: merId,
      invoiceNo: invoiceNo,
      merTrxId: merTrxId,
    );
  }

  String getJavaScriptCode(Map<String, dynamic> transaction) {
    String fields = _mapToFormattedString(transaction);
    return '''
            const form = document.createElement('form');
            form.id = 'megapayForm';
            form.name = 'megapayForm';
            form.method = 'POST';
            form.action = '$vnptEpayDomain/pg_was/order/Minit.do';

            const createHiddenInput = (name, value) => {
              const input = document.createElement('input');
              input.type = 'hidden';
              input.name = name;
              input.value = value;
              return input;
            };

            const fields = $fields;

            fields.forEach(([name, value]) => {
              const input = createHiddenInput(name, value);
              form.appendChild(input);
            });

            const submitBtn = document.createElement('button');
            submitBtn.type = 'button';
            submitBtn.className = 'btn btn-primary';
            submitBtn.name = 'btnSubmit';
            submitBtn.value = 'btnSubmit';
            submitBtn.id = 'submitBtn';
            submitBtn.hidden = 'true';
            submitBtn.textContent = 'Submit';

            submitBtn.addEventListener('click', function() {
              form.submit();
            });

            form.appendChild(submitBtn);

            document.body.appendChild(form);
            form.submit();
          ''';
  }
}
