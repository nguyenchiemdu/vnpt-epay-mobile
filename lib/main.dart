import 'package:flutter/material.dart';
import 'package:vnpt_epay_mobile/api/api.dart';
import 'package:vnpt_epay_mobile/enum/bank_code.dart';
import 'package:vnpt_epay_mobile/enum/currency.dart';
import 'package:vnpt_epay_mobile/enum/language.dart';
import 'package:vnpt_epay_mobile/enum/pay_option.dart';
import 'package:vnpt_epay_mobile/enum/pay_type.dart';
import 'package:vnpt_epay_mobile/models/epay_transaction.dart';
import 'package:vnpt_epay_mobile/models/transaction.dart';
import 'package:vnpt_epay_mobile/payment_browser.dart';
import 'package:vnpt_epay_mobile/vpnt_epay/vnpt_epay_hepler.dart';
import 'package:vnpt_epay_mobile/widget/app_text_field.dart';
import 'package:vnpt_epay_mobile/widget/dropdown_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void enterPayment() async {
    String userId = _userIdController.text;
    String buyerFirstNm = _firstNameController.text;
    String buyerLastNm = _lastNameController.text;
    String buyerPhone = _phoneController.text;
    int amount = int.parse(_amountController.text);
    String goodsNm = _productNameController.text;
    Currency currency = Currency.VND;
    PayType payType = _payType;
    BankCode bankCode = _bankCode;
    PayOption payOption = _payOption;
    String payToken = _payWithTokenController.text;
    Language language = _language;

    // Call to BE to create Transaction and get Transaction Id

    Transaction transactionBody = Transaction(
      userId: userId,
      amount: amount,
      goodsNm: goodsNm,
      currency: currency,
      payType: payType,
      bankCode: bankCode,
      payOption: payOption,
    );

    final json = await Api()
        .post('/transaction/create', data: transactionBody.toJson())
        .then((res) => res['data']);
    String transactionId = json['_id'];

    EpayTransaction epayTransaction = VnptEpayHelper().createTransaction(
      amount: amount,
      buyerFirstNm: buyerFirstNm,
      buyerLastNm: buyerLastNm,
      buyerPhone: buyerPhone,
      userId: userId,
      goodsNm: goodsNm,
      payToken: payToken,
      payType: payType,
      payOption: payOption,
      bankCode: bankCode,
      language: language,
      transactionId: transactionId,
    );
    PaymentBrowser(transaction: epayTransaction.toJson()).openPaymentBrowser();
  }

  final TextEditingController _amountController =
      TextEditingController(text: '10000');
  final TextEditingController _firstNameController =
      TextEditingController(text: 'Huyen');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Hoang');
  final TextEditingController _phoneController =
      TextEditingController(text: '0989593059');
  final TextEditingController _productNameController =
      TextEditingController(text: 'IPhone 11');
  final TextEditingController _userIdController =
      TextEditingController(text: '6539d6cf197f81e8317056f7');
  final TextEditingController _payWithTokenController =
      TextEditingController(text: '');
  PayOption _payOption = PayOption.EMPTY;
  PayType _payType = PayType.NO;
  BankCode _bankCode = BankCode.EMPTY;
  Language _language = Language.VN;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AppTextField(
                        label: ('Amount'),
                        controller: _amountController,
                      ),
                      AppTextField(
                        label: ('First Name'),
                        controller: _firstNameController,
                      ),
                      AppTextField(
                        label: ('Last Name'),
                        controller: _lastNameController,
                      ),
                      AppTextField(
                        label: ('Phone'),
                        controller: _phoneController,
                      ),
                      AppTextField(
                        label: ('Product Name'),
                        controller: _productNameController,
                      ),
                      AppTextField(
                        label: ('User Id'),
                        controller: _userIdController,
                      ),
                      AppTextField(
                        label: ('Pay Token'),
                        controller: _payWithTokenController,
                      ),
                      AppDropdownButton<PayOption>(
                        onChanged: (value) {
                          _payOption = value!;
                        },
                        initValue: PayOption.EMPTY,
                        textBuilder: (value) => value.name,
                        items: PayOption.values.map((e) => e).toList(),
                      ),
                      AppDropdownButton<PayType>(
                        initValue: PayType.NO,
                        onChanged: (value) {
                          _payType = value!;
                        },
                        textBuilder: (value) => value.name,
                        items: PayType.values.map((e) => e).toList(),
                      ),
                      AppDropdownButton<BankCode>(
                        initValue: BankCode.EMPTY,
                        onChanged: (value) {
                          _bankCode = value!;
                        },
                        textBuilder: (value) => value.name,
                        items: BankCode.values.map((e) => e).toList(),
                      ),
                      AppDropdownButton<Language>(
                        initValue: Language.VN,
                        onChanged: (value) {
                          _language = value!;
                        },
                        textBuilder: (value) => value.name,
                        items: Language.values.map((e) => e).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: enterPayment, child: const Text('Enter Payment')),
            ],
          ),
        ),
      ),
    );
  }
}
