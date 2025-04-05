import 'package:agristant/common/adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    // print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    // print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    // print("Stopped $url");
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    // print("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    // print("Progress: $progress");
  }

  @override
  void onExit() {
    // print("Browser closed!");
  }
}

class Browser extends StatefulWidget {
  const Browser({super.key, required this.value});
  final String value;
  @override
  BrowserState createState() => BrowserState();
}

class BrowserState extends State<Browser> {
  final browser = MyInAppBrowser();

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: true),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode));

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
        body: Column(
      children: [
        Container(
          color: Colors.white,
          height: Adapt.statusBarHeight,
          width: Adapt.screenWidth,
        ),
        Expanded(
          child: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri(
                      "https://www.bing.com/search?q=${widget.value}&form=QBLH"))),
        )
      ],
    ));
  }
}
