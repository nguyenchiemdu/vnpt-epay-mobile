import 'dart:math';
import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:vnpt_epay_mobile/enum/bank_code.dart';
import 'package:vnpt_epay_mobile/enum/country_code.dart';
import 'package:vnpt_epay_mobile/enum/currency.dart';
import 'package:vnpt_epay_mobile/enum/language.dart';
import 'package:vnpt_epay_mobile/enum/pay_option.dart';
import 'package:vnpt_epay_mobile/enum/pay_type.dart';
import 'package:vnpt_epay_mobile/enum/window_type.dart';
import 'package:vnpt_epay_mobile/models/transaction.dart';
// import 'package:encrypt/encrypt.dart';
import 'package:dart_des/dart_des.dart';
import 'package:convert/convert.dart';

class VnptEpayHelper {
  final String encodeKey =
      'rf8whwaejNhJiQG2bsFubSzccfRc/iRYyGUn6SPmT6y/L7A2XABbu9y4GvCoSTOTpvJykFi6b1G0crU8et2O0Q==';
  String get keyEncrypt => encodeKey.substring(encodeKey.length - 24);
  String get keyDecrypt => encodeKey.substring(0, 24);

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

  String _des3Encrypt(String data, String keyString) {
    final plainText = utf8.encode(data);

    DES3 des3CBC = DES3(
      key: keyString.codeUnits,
      mode: DESMode.ECB,
      paddingType: DESPaddingType.PKCS5,
    );
    final encrypted = des3CBC.encrypt(plainText);
    return hex.encode(encrypted);
  }

  String _des3Decrypt(String cipher, String keyString) {
    final encrypted = hex.decode(cipher);
    DES3 des3CBC = DES3(
      key: keyString.codeUnits,
      mode: DESMode.ECB,
      paddingType: DESPaddingType.PKCS5,
    );
    final decrypted = des3CBC.decrypt(encrypted);
    return utf8.decode(decrypted);
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
      {required String merTrxId,
      required DateTime date,
      int amount = 2000,
      String? payToken}) {
    String timeStamp = generateTimeStamp(date);
    String createMerchantToken =
        '$timeStamp$merTrxId$merId$amount${payToken ?? ''}$encodeKey';
    String merchantToken = _encrypt(createMerchantToken);
    return merchantToken;
  }

  String generateInvoiceNo({required DateTime date}) {
    String fullDate =
        '${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}${date.millisecond}';
    String prefixStr = 'OrdNo';
    return prefixStr + fullDate;
  }

  String encodePayToken(String payToken) {
    var cipher = payToken;
    final plainText = _des3Decrypt(cipher, keyDecrypt);
    cipher = _des3Encrypt(plainText, keyEncrypt);
    return cipher;
  }

  Transaction createTransaction({
    required String amount,
    required String goodsNm,
    required String buyerFirstNm,
    required String buyerLastNm,
    required String buyerPhone,
    required String userId,
    PayType payType = PayType.DC,
    BankCode bankCode = BankCode.EMPTY,
    String payToken = '',
  }) {
    Currency currency = Currency.VND;
    Language userLanguage = Language.VN;
    WindowType windowType = WindowType.mobile;
    String description = 'TNUWKCMFVW';
    PayOption payOption = payToken.isEmpty
        ? PayOption.PAY_CREATE_TOKEN
        : PayOption.PAY_WITH_TOKEN;
    Color windowColor = const Color(0xff0061e3);
    if (payToken.isNotEmpty) {
      payToken = encodePayToken(payToken);
    }

    /// Generated Fields
    DateTime date = DateTime.now();
    String timeStamp = generateTimeStamp(date);
    String invoiceNo = generateInvoiceNo(date: date);
    String merTrxId = generateMerTrxId(date: date);
    String merchantToken = generateMerchantToken(
        payToken: payToken,
        merTrxId: merTrxId,
        date: date,
        amount: int.parse(amount));
    return Transaction(
      buyerCountry: CountryCode.en,
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
      bankCode: bankCode,
      reqDomain: reqDomain,
      windowColor: windowColor,
      payToken: payToken,
      merchantToken: merchantToken,
      timeStamp: timeStamp,
      merId: merId,
      invoiceNo: invoiceNo,
      merTrxId: merTrxId,
    );
  }

  String getJavaScriptCode(Map<String, dynamic> transaction) {
    String fields = _mapToFormattedString(transaction);
    // print(fields.substring(0, 93));
    // print(fields.substring(93));
    final jsScript = '''
            const form = document.createElement('form');
            form.id = 'megapayForm';
            form.name = 'megapayForm';
            form.method = 'POST';
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
            document.body.appendChild(form);
            openPayment(1, '$reqDomain');
          ''';
    return jsScript;
  }
}
