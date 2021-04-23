import 'package:auto_route/auto_route.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


///使用fluro进行路由管理
class MyRouter {
  static FluroRouter router;

  static void init() {
    router = FluroRouter();
    configureRoutes(router);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("route is not find !");
      return null;
    });

  }

  static void navigateTo(BuildContext context, String path) {
    router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }

  static void goWeb(BuildContext context, String url, String title) {
    navigateTo(context,
        "/web?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}");
  }

  //=============AutoRoute===============//

  static ExtendedNavigatorState get navigator => ExtendedNavigator.root;

  static void push(String routeName) {
    navigator.push(routeName);
  }

  static void replace(String routeName) {
    navigator.replace(routeName);
  }
}
