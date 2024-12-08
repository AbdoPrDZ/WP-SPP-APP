import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../src/src.dart';
import 'home/tabs/subscriptions/subscription/watch/page.dart';

class OldHomePage extends StatefulWidget {
  static const String name = '/home/watch';

  const OldHomePage({super.key});

  @override
  State<OldHomePage> createState() => _OldHomePageState();
}

class _OldHomePageState extends State<OldHomePage> {
  late InAppWebViewController webView;

  final CookieManager _cookieManager = CookieManager.instance();

  WatchPageData pageData = Get.arguments as WatchPageData;

  WebUri get homeUrl => WebUri.uri(
        // Uri.parse("https://facebook.com"),
        Uri.parse(pageData.subscriptionInfo.hostUrl),
      );

  bool isUrlBlocked(String url) {
    // List of blocked routes with '*' as a wildcard
    List<String> blockedRoutes = [
      // r"https://workshop.autodata-group.com/w1/manage-account.*",
      // r"https://workshop.autodata-group.com/settings.*",
      // r"https://workshop.autodata-group.com/user.*",
      // r"https://autodata-group.com/es/noticias.*",
      // r"https://workshop.autodata-training.com.*",
    ];

    // Iterate over blocked routes and check if the URL matches any of them
    for (String blockedRoute in blockedRoutes) {
      RegExp regex = RegExp(blockedRoute);
      if (regex.hasMatch(url)) {
        return true; // URL is blocked
      }
    }

    return false; // URL is allowed
  }

  @override
  void initState() {
    _loadCookies();
    super.initState();
  }

  Future _loadCookies() async {
    // _cookieManager.setCookie(
    //   url: homeUrl,
    //   name: "SESSd965b47fdd2684807fd560c91c3e21b6",
    //   value: "IfkZN2jZ3wZ3vRY3IPpwyDh1dhoPCSy51c19xdhkY3M",
    //   domain: ".workshop.autodata-group.com",
    //   isSecure: true,
    // );
    await _cookieManager.deleteAllCookies();

    for (final cookie in pageData.subscriptionInfo.cookies) {
      print('cookies item: $cookie');
      _cookieManager.setCookie(
        url: homeUrl,
        name: cookie.name,
        value: cookie.value,
        isSecure: cookie.secure,
        domain: cookie.domain,
        isHttpOnly: cookie.httpOnly,
        path: cookie.path ?? '/',
        // webViewController: webView,
      );
    }
    // _cookieManager.setCookie(
    //   url: homeUrl,
    //   name: "c_user",
    //   value: "100008024286034",
    //   domain: ".${homeUrl.host}",
    //   // isSecure: true,
    // );
    // _cookieManager.setCookie(
    //   url: homeUrl,
    //   name: "xs",
    //   value:
    //       "6%3AsO-6AW1dV7DXxA%3A2%3A1729846518%3A-1%3A537%3A%3AAcVW9nQ5dAzGh2Ysc6bJ7qb6uo52OWs5_DJ-PONkYg",
    //   domain: ".${homeUrl.host}",
    //   // isSecure: true,
    // );
  }

  bool _loading = true;

  bool canGoBack = false;
  bool canGoForward = false;

  get goHome => !_loading
      ? () async {
          _loading = true;
          setState(() {});

          webView.loadUrl(urlRequest: URLRequest(url: homeUrl));
        }
      : null;

  get goBack => !_loading && canGoBack
      ? () async {
          if (await webView.canGoBack()) {
            _loading = true;
            setState(() {});

            webView.goBack();
          }
        }
      : null;

  get goForward => !_loading && canGoForward
      ? () async {
          if (await webView.canGoForward()) {
            _loading = true;
            setState(() {});

            webView.goForward();
          }
        }
      : null;

  double pageLoadProgress = 0;
  get refreshPage => _loading
      ? null
      : () {
          _loading = true;
          setState(() {});
          webView.reload();
        };

  Widget buildAction(IconData icon, String tooltip, VoidCallback? onPressed) =>
      // IconButton(
      //   icon: Icon(icon),
      //   onPressed: onPressed,
      //   tooltip: tooltip,
      // );
      ButtonView.icon(
        margin: const EdgeInsets.only(right: 4),
        iconSize: 25,
        width: 30,
        height: 30,
        // backgroundColor: Colors.transparent,
        iconColor: Colors.black,
        borderColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: icon,
      );

  PreferredSizeWidget? _buildAppBar(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 25),
        child: Container(
          height: kToolbarHeight + 25,
          color: UIColors.primary,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    buildAction(
                      Icons.home,
                      'Home Page',
                      goHome,
                    ),
                    buildAction(
                      Icons.arrow_back,
                      'Back to URL',
                      goBack,
                    ),
                    buildAction(
                      Icons.refresh,
                      'Refresh',
                      refreshPage,
                    ),
                    buildAction(
                      Icons.arrow_forward,
                      'Forward to URL',
                      goForward,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pageData.subscription.name,
                              style:
                                  TextStyles.midTitleBold + TextStyles.ellipsis,
                            ),
                            Text(
                              pageData.subscription.description,
                              style: TextStyles.midTitle + TextStyles.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    buildAction(
                      Icons.exit_to_app,
                      'Back to App Home',
                      () => RouteManager.to(
                        PagesInfo.home,
                        clearHeaders: true,
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                value: pageLoadProgress,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: _buildAppBar(context),
          body: SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: InAppWebView(
                    initialSettings: InAppWebViewSettings(
                      useShouldOverrideUrlLoading: true,
                    ),
                    initialUrlRequest: URLRequest(
                      url: homeUrl,
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    shouldInterceptRequest: (controller, request) async {
                      print('intercept request: ${request.url}');
                      if (isUrlBlocked("${request.url}")) {
                        return WebResourceResponse(
                          statusCode: 302,
                          headers: {
                            'Location': '$homeUrl',
                          },
                        );
                      }
                      return null;
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      final url = navigationAction.request.url;

                      print('override url: $url');

                      // return NavigationActionPolicy.CANCEL;
                      return url != null && isUrlBlocked("$url")
                          ? NavigationActionPolicy.CANCEL
                          : NavigationActionPolicy.ALLOW;
                    },
                    onLoadStart: (controller, url) {
                      print("started $url");
                      setState(() {
                        _loading = true;
                      });
                    },
                    onLoadStop: (controller, url) async {
                      // if (url != null) {
                      //   List<Cookie> cookies = await _cookieManager.getCookies(
                      //     url: url,
                      //   );
                      //   for (var cookie in cookies) {
                      //     print("${cookie.name} ${cookie.value}");
                      //   }
                      // }
                      print("stopped $url");
                      setState(() {
                        _loading = false;
                      });
                    },
                  ),
                ),
                if (_loading)
                  Positioned.fill(
                    child: Container(
                      color: const Color.fromARGB(102, 0, 0, 0),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
