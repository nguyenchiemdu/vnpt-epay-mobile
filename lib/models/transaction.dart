import 'package:flutter/material.dart';
import 'package:vnpt_epay_mobile/enum/country_code.dart';
import 'package:vnpt_epay_mobile/enum/currency.dart';
import 'package:vnpt_epay_mobile/enum/language.dart';
import 'package:vnpt_epay_mobile/enum/pay_option.dart';
import 'package:vnpt_epay_mobile/enum/pay_type.dart';
import 'package:vnpt_epay_mobile/enum/window_type.dart';

class Transaction {
  /// User Information

  final CountryCode buyerCountry;
  final String buyerLastNm;
  final String buyerFirstNm;
  final String buyerPhone;
  final String userId;

  /// Order Infor

  final int amount;
  // Name of the product
  final String goodsNm;
  // Url to redirect to our app
  final String callBackUrl;
  // Url to send transaction data to server
  final String notiUrl;
  // Unit of currency, currently support: VND
  final Currency currency;
  // [VN,EN,KR], currently support: VN
  final Language userLanguage;
  // 0 : UI for Desktop, 1: UI for Mobile
  final WindowType windowType;
  final String description;
  // [IC,DC,EW,NO]
  final PayType payType;
  final PayOption payOption;
  final String reqDomain;
  // Background color for payment window
  final Color windowColor;

  /// Generated Fields

  final String payToken;
  final String merchantToken;
  final String timeStamp;
  final String merId;
  final String invoiceNo;
  final String merTrxId;

  Transaction(
      {required this.buyerCountry,
      required this.buyerLastNm,
      required this.buyerFirstNm,
      required this.buyerPhone,
      required this.userId,
      required this.amount,
      required this.goodsNm,
      required this.callBackUrl,
      required this.notiUrl,
      required this.currency,
      required this.userLanguage,
      required this.windowType,
      required this.description,
      required this.payType,
      required this.payOption,
      required this.reqDomain,
      required this.windowColor,
      required this.payToken,
      required this.merchantToken,
      required this.timeStamp,
      required this.merId,
      required this.invoiceNo,
      required this.merTrxId});
  // Genertae toJson function
  Map<String, dynamic> toJson() {
    return {
      'buyerCountry': buyerCountry.name,
      'buyerLastNm': buyerLastNm,
      'buyerFirstNm': buyerFirstNm,
      'buyerPhone': buyerPhone,
      'userId': userId,
      'amount': amount,
      'goodsNm': goodsNm,
      'callBackUrl': callBackUrl,
      'notiUrl': notiUrl,
      'currency': currency.name,
      'userLanguage': userLanguage.name,
      'windowType': windowType.getValue(),
      'description': description,
      'payType': payType.name,
      'payOption': payOption.name,
      'reqDomain': reqDomain,
      'windowColor': _getColorCode(),
      'payToken': payToken,
      'merchantToken': merchantToken,
      'timeStamp': timeStamp,
      'merId': merId,
      'invoiceNo': invoiceNo,
      'merTrxId': merTrxId,
    };
  }

  String _getColorCode() {
    String colorString = windowColor.toString();
    colorString = colorString.replaceAll('Color(0xff', '#');
    colorString = colorString.replaceAll(')', '');
    return colorString;
  }
}
