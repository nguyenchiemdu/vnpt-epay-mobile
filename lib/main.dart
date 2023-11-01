import 'package:flutter/material.dart';
import 'package:vnpt_epay_mobile/api.dart';
import 'package:vnpt_epay_mobile/inapp_browser.dart';

void main() {
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
    const data = {
      "goodsNm": "IPhone 11 Plus",
      "amount": 3000,
      "userFee": 0,
      "payType": "NO",
      "bankCode": "",
      "windowColor": "#0061e3",
      "payOption": "PAY_CREATE_TOKEN",
      "merId": "MGPDEMO001",
      "tokenId": ""
    };
    debugPrint('Loading... Transaction Data');
    final response = await Api().post('/home/process/mobile', data: data);
    final transaction = response['data'];
    debugPrint(transaction.toString());
    MyInAppBrowser(transaction: transaction as Map<String, dynamic>)
        .openFile(assetFilePath: 'assets/index.html', options: options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: enterPayment, child: const Text('Enter Payment')),
          ],
        ),
      ),
    );
  }
}
