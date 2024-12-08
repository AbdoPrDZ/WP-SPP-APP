part of 'page.dart';

class WatchController extends GetxController {
  final MainService mainService = Get.find();

  WatchPageData pageData = Get.arguments as WatchPageData;

  InAppWebViewController? webView;
  final _cookieManager = CookieManager.instance();

  WebUri get homeUrl => WebUri.uri(
        Uri.parse(pageData.subscriptionInfo.hostUrl),
      );

  bool loading = true;

  bool isUrlBlocked(String url) {
    List<String> blockedUrls = pageData.subscriptionInfo.blockedUrls;

    for (String blockedUrl in blockedUrls) {
      final httpUrl = url.replaceAll('https:', 'http:').trim();
      final httpBlockedUrl = blockedUrl.replaceAll('https:', 'http:').trim();

      if (httpUrl == httpBlockedUrl || httpUrl.contains(httpBlockedUrl)) {
        print('blocked: $url');
        return true;
      }
    }
    print('allowed: $url');

    return false;
  }

  Future loadCookies() async {
    final subscriptionInfo = pageData.subscriptionInfo;
    await _cookieManager.deleteAllCookies();

    for (final cookie in subscriptionInfo.cookies) {
      _cookieManager.setCookie(
        url: homeUrl,
        name: cookie.name,
        value: cookie.value,
        isSecure: cookie.secure,
        domain: cookie.domain,
        isHttpOnly: cookie.httpOnly,
        path: cookie.path ?? '/',
        webViewController: webView,
      );
    }

    update();
  }

  void onWebViewCreated(InAppWebViewController controller) async {
    webView = controller;
    await loadCookies();
    webView?.loadUrl(urlRequest: URLRequest(url: homeUrl));
  }

  Future<WebResourceResponse?> shouldInterceptRequest(
    controller,
    request,
  ) async {
    if (isUrlBlocked("${request.url}")) {
      return WebResourceResponse(
        statusCode: 302,
        headers: {
          'Location': '$homeUrl',
        },
      );
    }
    return null;
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
    controller,
    navigationAction,
  ) async {
    final url = navigationAction.request.url;

    return url != null && isUrlBlocked("$url")
        ? NavigationActionPolicy.CANCEL
        : NavigationActionPolicy.ALLOW;
  }

  void onLoadStart(controller, url) {
    loading = true;
    update();
  }

  void onLoadStop(InAppWebViewController controller, url) async {
    canGoBack = await webView!.canGoBack();
    canGoForward = await webView!.canGoForward();
    pageLoadProgress = 0;
    loading = false;

    update();
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    pageLoadProgress = progress / 100;
    if (progress == 100) {
      onLoadStop(controller, null);
    }
    update();
  }

  void onError(
    InAppWebViewController controller,
    WebResourceRequest request,
    error,
  ) {
    print('error: $error');
    DialogsView.message('Error', '$error').show();
    loading = false;
    pageLoadProgress = 0;
    update();
  }

  bool canGoBack = false;
  bool canGoForward = false;

  get goHome => !loading
      ? () async {
          loading = true;
          update();

          webView!.loadUrl(urlRequest: URLRequest(url: homeUrl));
        }
      : null;

  get goBack => !loading && canGoBack
      ? () async {
          if (await webView!.canGoBack()) {
            loading = true;
            update();

            webView!.goBack();
          }
        }
      : null;

  get goForward => !loading && canGoForward
      ? () async {
          if (await webView!.canGoForward()) {
            loading = true;
            update();

            webView!.goForward();
          }
        }
      : null;

  double pageLoadProgress = 0;
  get refreshPage => loading
      ? null
      : () {
          loading = true;
          update();
          webView!.reload();
        };
}

extension MUri on Uri {
  Uri copyWith({
    String? scheme,
    String? userInfo,
    String? host,
    int? port,
    String? path,
    Iterable<String>? pathSegments,
    String? query,
    Map<String, dynamic>? queryParameters,
    String? fragment,
  }) =>
      Uri(
        scheme: scheme ?? this.scheme,
        userInfo: userInfo ?? this.userInfo,
        host: host ?? this.host,
        port: port ?? this.port,
        path: path ?? this.path,
        pathSegments: pathSegments ?? this.pathSegments,
        query: query ?? this.query,
        queryParameters: queryParameters ?? this.queryParameters,
        fragment: fragment ?? this.fragment,
      );
}
