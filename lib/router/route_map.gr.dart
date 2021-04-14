// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../page/device/device_page.dart';
import '../page/interval/interval_page.dart';
import '../page/notification/notice_page.dart';
import '../page/page_index.dart';
import '../page/rule/rules_page.dart';
import '../page/settings.dart';
import '../page/theme_color.dart';
import '../routes/cloud_route.dart';
import '../routes/home_route.dart';
import '../routes/user_route.dart';

class Routes {
  static const String indexPage = '/';
  static const String homeRoute = '/home-route';
  static const String cloudRoute = '/cloud-route';
  static const String userRoute = '/user-route';
  static const String settingPage = '/page/settings';
  static const String themeColorPage = '/theme-color-page';
  static const String devicePage = '/page/device/device_page';
  static const String intervalPage = '/page/interval/interval_page';
  static const String noticePage = '/page/notification/notice_page';
  static const String rulesPage = '/page/rule/rules_page';
  static const all = <String>{
    indexPage,
    homeRoute,
    cloudRoute,
    userRoute,
    settingPage,
    themeColorPage,
    devicePage,
    intervalPage,
    noticePage,
    rulesPage,
  };
}

class RouterMap extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.indexPage, page: IndexPage),
    RouteDef(Routes.homeRoute, page: HomeRoute),
    RouteDef(Routes.cloudRoute, page: CloudRoute),
    RouteDef(Routes.userRoute, page: UserRoute),
    RouteDef(Routes.settingPage, page: SettingPage),
    RouteDef(Routes.themeColorPage, page: ThemeColorPage),
    RouteDef(Routes.devicePage, page: DevicePage),
    RouteDef(Routes.intervalPage, page: IntervalPage),
    RouteDef(Routes.noticePage, page: NoticePage),
    RouteDef(Routes.rulesPage, page: RulesPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    IndexPage: (data) {
      final args = data.getArgs<IndexPageArguments>(
        orElse: () => IndexPageArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            IndexPage(key: args.key),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    HomeRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => HomeRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    CloudRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => CloudRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    UserRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => UserRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    SettingPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SettingPage(),
        settings: data,
      );
    },
    ThemeColorPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ThemeColorPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    DevicePage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => DevicePage(),
        settings: data,
      );
    },
    IntervalPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => IntervalPage(),
        settings: data,
      );
    },
    NoticePage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => NoticePage(),
        settings: data,
      );
    },
    RulesPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => RulesPage(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// IndexPage arguments holder class
class IndexPageArguments {
  final Key key;
  IndexPageArguments({this.key});
}
