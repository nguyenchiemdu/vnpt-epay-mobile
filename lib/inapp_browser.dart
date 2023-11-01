import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyInAppBrowser extends InAppBrowser {
  final Map<String, dynamic> transaction;
  MyInAppBrowser({required this.transaction});
  String mapToFormattedString(Map<String, dynamic> data) {
    List<String> formattedList = data.entries.map((entry) {
      return "['${entry.key}', '${entry.value}'],";
    }).toList();

    String formattedString = '''[
    ${formattedList.join('\n    ')}
  ]''';

    return formattedString;
  }

  bool isFormSubmitted = false;
  @override
  Future onLoadStop(url) async {
    if (!isFormSubmitted) {
      isFormSubmitted = true;
      final fields = (mapToFormattedString(transaction));
      super.webViewController.evaluateJavascript(source: '''
            const form = document.createElement('form');
            form.id = 'megapayForm';
            form.name = 'megapayForm';
            form.method = 'POST';
            form.action = 'https://pg.megapay.vn/pg_was/order/Minit.do';

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
          ''');
    }
  }
}

final options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(hideUrlBar: true),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)));
