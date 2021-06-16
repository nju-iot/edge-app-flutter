// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MyAction.dart';

import '../page/Login/login.dart';
import '../page/Login/register.dart';
import '../page/device/device_add.dart';
import '../page/device/device_info.dart';
import '../page/device/device_page.dart';
import '../page/device/profile_info.dart';
import '../page/device/service_info.dart';
import '../page/interval/interval_action_info.dart';
import '../page/interval/interval_actions.dart';
import '../page/interval/interval_actions_add.dart';
import '../page/interval/interval_add.dart';
import '../page/interval/interval_info.dart';
import '../page/interval/interval_page.dart';
import '../page/notification/notice_page.dart';
import '../page/notification/notification_info.dart';
import '../page/notification/subscription_add.dart';
import '../page/notification/subscription_info.dart';
import '../page/page_index.dart';
import '../page/rule/rule_info.dart';
import '../page/rule/rules_add.dart';
import '../page/rule/rules_page.dart';
import '../page/rule/stream_info.dart';
import '../page/rule/streams_add.dart';
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
  static const String intervalAddPage = '/page/interval/add';
  static const String intervalActionsAddPage = '/page/interval/actions_add';
  static const String _actionInfoPage =
      '/page/interval/action_info/:actionInfo';
  static String actionInfoPage({@required dynamic actionInfo}) =>
      '/page/interval/action_info/$actionInfo';
  static const String intervalActionsPage = '/page/interval/actions';
  static const String _intervalInfoPage = '/page/interval/info/:id';
  static String intervalInfoPage({@required dynamic id}) =>
      '/page/interval/info/$id';
  static const String streamsAddPage = '/page/rules_engine/streams/add';
  static const String _streamInfoPage = '/page/rules_engine/streams/info/:name';
  static String streamInfoPage({@required dynamic name}) =>
      '/page/rules_engine/streams/info/$name';
  static const String rulesAddPage = '/page/rules_engine/rules/add';
  static const String _ruleInfoPage = '/page/rules_engine/rules/info/:id';
  static String ruleInfoPage({@required dynamic id}) =>
      '/page/rules_engine/rules/info/$id';
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
    intervalAddPage,
    intervalActionsAddPage,
    _actionInfoPage,
    intervalActionsPage,
    _intervalInfoPage,
    streamsAddPage,
    _streamInfoPage,
    rulesAddPage,
    _ruleInfoPage,
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
    RouteDef(Routes.intervalAddPage, page: IntervalAddPage),
    RouteDef(Routes.intervalActionsAddPage, page: IntervalActionsAddPage),
    RouteDef(Routes._actionInfoPage, page: ActionInfoPage),
    RouteDef(Routes.intervalActionsPage, page: IntervalActionsPage),
    RouteDef(Routes._intervalInfoPage, page: IntervalInfoPage),
    RouteDef(Routes.streamsAddPage, page: StreamsAddPage),
    RouteDef(Routes._streamInfoPage, page: StreamInfoPage),
    RouteDef(Routes.rulesAddPage, page: RulesAddPage),
    RouteDef(Routes._ruleInfoPage, page: RuleInfoPage),
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
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    HomeRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => HomeRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    CloudRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => CloudRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    UserRoute: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => UserRoute(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    LoginPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    RegisterPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
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
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    SubAddPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SubAddPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    IntervalAddPage: (data) {
      final args = data.getArgs<IntervalAddPageArguments>(
        orElse: () => IntervalAddPageArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            IntervalAddPage(intervalString: args.interval),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    IntervalActionsAddPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            IntervalActionsAddPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    ActionInfoPage: (data) {
      final args = data.getArgs<ActionInfoPageArguments>(
        orElse: () => ActionInfoPageArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => ActionInfoPage(
          data.pathParams['actionInfo'].value,
          key: args.key,
        ),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    IntervalActionsPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            IntervalActionsPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    IntervalInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            IntervalInfoPage(data.pathParams['id'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    StreamsAddPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const StreamsAddPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    StreamInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StreamInfoPage(data.pathParams['name'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    RulesAddPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RulesAddPage(),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
      );
    },
    RuleInfoPage: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RuleInfoPage(data.pathParams['id'].stringValue),
        settings: data,
        opaque: false,
        barrierDismissible: false,
        transitionsBuilder: getTransitions,
        transitionDuration: const Duration(milliseconds: 1000),
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

/// IntervalAddPage arguments holder class
class IntervalAddPageArguments {
  final String interval;
  IntervalAddPageArguments({this.interval = ""});
}

/// ActionInfoPage arguments holder class
class ActionInfoPageArguments {
  final Key key;
  ActionInfoPageArguments({this.key});
}
