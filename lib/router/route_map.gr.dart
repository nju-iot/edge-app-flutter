// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../page/Login/login.dart';
import '../page/Login/register.dart';
import '../page/device/device_add.dart';
import '../page/device/device_info.dart';
import '../page/device/device_page.dart';
import '../page/device/profile_info.dart';
import '../page/device/service_info.dart';
import '../page/interval/interval_page.dart';
import '../page/notification/notice_page.dart';
import '../page/notification/notification_info.dart';
import '../page/notification/subscription_add.dart';
import '../page/notification/subscription_info.dart';
import '../page/page_index.dart';
import '../page/rule/rules_page.dart';
import '../page/settings.dart';
import '../page/theme_color.dart';
import '../routes/cloud_route.dart';
import '../routes/home_route.dart';
import '../routes/user_route.dart';
import 'route_map.dart';

class Routes {
  static const String indexPage = '/';
  static const String homeRoute = '/home-route';
  static const String cloudRoute = '/cloud-route';
  static const String userRoute = '/user-route';
  static const String loginPage = '/login-page';
  static const String registerPage = '/register-page';
  static const String settingPage = '/page/settings';
  static const String themeColorPage = '/theme-color-page';
  static const String devicePage = '/page/device/device_page';
  static const String intervalPage = '/page/interval/interval_page';
  static const String noticePage = '/page/notification/notice_page';
  static const String rulesPage = '/page/rule/rules_page';
  static const String _deviceInfoPage = '/page/device/device_info/:name';
  static String deviceInfoPage({@required dynamic name}) =>
      '/page/device/device_info/$name';
  static const String deviceAddPage = '/page/device/device_add';
  static const String _serviceInfoPage = '/page/device/service_info/:name';
  static String serviceInfoPage({@required dynamic name}) =>
      '/page/device/service_info/$name';
  static const String _profileInfoPage = '/page/device/profile_info/:name';
  static String profileInfoPage({@required dynamic name}) =>
      '/page/device/profile_info/$name';
  static const String _subInfoPage = '/page/notification/sub_info/:id';
  static String subInfoPage({@required dynamic id}) =>
      '/page/notification/sub_info/$id';
  static const String _notificationInfoPage =
      '/page/notification/notification_info/:slug';
  static String notificationInfoPage({@required dynamic slug}) =>
      '/page/notification/notification_info/$slug';
  static const String subAddPage = '/page/notification/subscription_add';
  static const all = <String>{
    indexPage,
    homeRoute,
    cloudRoute,
    userRoute,
    loginPage,
    registerPage,
    settingPage,
    themeColorPage,
    devicePage,
    intervalPage,
    noticePage,
    rulesPage,
    _deviceInfoPage,
    deviceAddPage,
    _serviceInfoPage,
    _profileInfoPage,
    _subInfoPage,
    _notificationInfoPage,
    subAddPage,
  };
}

class RouterMap extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.indexPage, page: IndexPage, guards: [AuthGuard]),
    RouteDef(Routes.homeRoute, page: HomeRoute),
    RouteDef(Routes.cloudRoute, page: CloudRoute),
    RouteDef(Routes.userRoute, page: UserRoute),
    RouteDef(Routes.loginPage, page: LoginPage),
    RouteDef(Routes.registerPage, page: RegisterPage),
    RouteDef(Routes.settingPage, page: SettingPage),
    RouteDef(Routes.themeColorPage, page: ThemeColorPage),
    RouteDef(Routes.devicePage, page: DevicePage),
    RouteDef(Routes.intervalPage, page: IntervalPage),
    RouteDef(Routes.noticePage, page: NoticePage),
    RouteDef(Routes.rulesPage, page: RulesPage),
    RouteDef(Routes._deviceInfoPage, page: DeviceInfoPage),
    RouteDef(Routes.deviceAddPage, page: DeviceAddPage),
    RouteDef(Routes._serviceInfoPage, page: ServiceInfoPage),
    RouteDef(Routes._profileInfoPage, page: ProfileInfoPage),
    RouteDef(Routes._subInfoPage, page: SubInfoPage),
    RouteDef(Routes._notificationInfoPage, page: NotificationInfoPage),
    RouteDef(Routes.subAddPage, page: SubAddPage),
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
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    HomeRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => HomeRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    CloudRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => CloudRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    UserRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => UserRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    LoginPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    RegisterPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
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
        transitionsBuilder: getTransitions,
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
    DeviceInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DeviceInfoPage(name: data.pathParams['name'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    DeviceAddPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DeviceAddPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    ServiceInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ServiceInfoPage(data.pathParams['name'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    ProfileInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfileInfoPage(data.pathParams['name'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    SubInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SubInfoPage(data.pathParams['id'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    NotificationInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NotificationInfoPage(data.pathParams['slug'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
      );
    },
    SubAddPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SubAddPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 800),
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
