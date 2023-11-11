import 'package:vnpt_epay_mobile/enum/bank_code.dart';
import 'package:vnpt_epay_mobile/enum/currency.dart';
import 'package:vnpt_epay_mobile/enum/pay_option.dart';
import 'package:vnpt_epay_mobile/enum/pay_type.dart';

class Transaction {
  final String? id;

  /// User Information
  final String userId;

  /// Order Infor

  final int amount;
  // Name of the product
  final String goodsNm;
  final Currency currency;
  // [IC,DC,EW,NO]
  final PayType payType;
  // Used  for eWallet payment, choose dirrectly type of Wallet
  final BankCode bankCode;
  final PayOption payOption;

  Transaction({
    this.id,
    required this.userId,
    required this.amount,
    required this.goodsNm,
    required this.currency,
    required this.payType,
    required this.bankCode,
    required this.payOption,
  });
  // Genertae toJson function
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'goodsNm': goodsNm,
      'currency': currency.name,
      'payType': payType.name,
      'bankCode': bankCode.codeValue,
      'payOption': payOption.getName,
    };
  }
}
