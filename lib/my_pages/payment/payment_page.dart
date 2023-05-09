import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/order_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../utils/my_constants.dart';

class PaymentPage extends StatefulWidget {
  final OrderModel orderModel;
  const PaymentPage({super.key, required this.orderModel});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  //Webview is coming from a plugin
  //Completer is kinda similiar like async and await
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController controllerGlobal;

  @override
  //When laoding the page for the first time
  void initState() {
    super.initState();
    selectedUrl =
        '${MyConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';
    //selectedUrl="https://mvs.bslmeiyu.com";
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    //WillPopScope is back buttoin for android. Just in case Android does not have one
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Payment"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => _exitApp(context),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: SizedBox(
            width: Dimensions.screenWidth,
            child: Stack(
              children: [
                WebView(
                  //WebView is Js based so we are not restricting any Js
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: selectedUrl,
                  gestureNavigationEnabled: true,
                  //We want to render a browser like Mozilla
                  userAgent:
                      'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.future
                        .then((value) => controllerGlobal = value);
                    _controller.complete(webViewController);
                    //_controller.future.catchError(onError)
                  },
                  //When it is laoding
                  onProgress: (int progress) {
                    print("WebView is loading (progress : $progress%)");
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      _isLoading = true;
                    });
                    print("printing urls $url");
                    _redirect(url);
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      _isLoading = false;
                    });
                    _redirect(url);
                  },
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _redirect(String url) {
    print("redirect");
    if (_canRedirect) {
      bool isSuccess =
          url.contains('success') && url.contains(MyConstants.BASE_URL);
      bool isFailed =
          url.contains('fail') && url.contains(MyConstants.BASE_URL);
      bool isCancel =
          url.contains('cancel') && url.contains(MyConstants.BASE_URL);
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
      }
      if (isSuccess) {
        Get.offNamed(RouteHelper.getOrderSuccessPage(
            widget.orderModel.id.toString(), 'success'));
      } else if (isFailed || isCancel) {
        Get.offNamed(RouteHelper.getOrderSuccessPage(
            widget.orderModel.id.toString(), 'fail'));
      } else {
        print("Encountered problem");
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      print("app exited");
      return true;
      // return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
    }
  }
}
