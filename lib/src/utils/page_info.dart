import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'page_data.dart';
import 'page_headers.dart';

class PageInfo<T extends PageData> {
  final String route;
  final Widget Function() page;
  final bool isUnAuth, skipAuthVerify;
  final PageHeaders pageHeaders;
  final List<GetMiddleware> middlewares;

  const PageInfo(
    this.route,
    this.page, {
    this.isUnAuth = false,
    this.skipAuthVerify = false,
    this.pageHeaders = const PageHeaders(),
    this.middlewares = const [],
  });

  @override
  operator ==(Object other) => other is String && other == route;

  @override
  int get hashCode => Object.hash(route, page);
}
