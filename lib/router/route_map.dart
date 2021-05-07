//占坑，页面多的时候，考虑弄一个页面路由映射表来管理页面
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/device/device_add.dart';
import 'package:flutter_app/page/device/device_info.dart';
import 'package:flutter_app/page/device/device_page.dart';
import 'package:flutter_app/page/device/profile_info.dart';
import 'package:flutter_app/page/device/service_info.dart';
import 'package:flutter_app/page/interval/interval_page.dart';
import 'package:flutter_app/page/notification/notice_page.dart';
import 'package:flutter_app/page/notification/notification_info.dart';
import 'package:flutter_app/page/notification/subscription_add.dart';
import 'package:flutter_app/page/notification/subscription_info.dart';
import 'package:flutter_app/page/page_index.dart';
import 'package:flutter_app/page/rule/rules_page.dart';
import 'package:flutter_app/page/settings.dart';
import 'package:flutter_app/page/theme_color.dart';
import 'package:flutter_app/routes/cloud_route.dart';
import 'package:flutter_app/routes/home_route.dart';
import 'package:flutter_app/routes/user_route.dart';

//页面路由映射表,在这里注册页面路由
@CustomAutoRouter(
  routes:<AutoRoute>[
    AutoRoute(page:IndexPage,initial: true),
    AutoRoute(page:HomeRoute),
    AutoRoute(page:CloudRoute),
    AutoRoute(page:UserRoute),
    CustomRoute(page:SettingPage,path:'/page/settings'),
    AutoRoute(page:ThemeColorPage),
    CustomRoute(page:DevicePage,path:'/page/device/device_page'),
    CustomRoute(page:IntervalPage,path:'/page/interval/interval_page'),
    CustomRoute(page:NoticePage,path:'/page/notification/notice_page'),
    CustomRoute(page:RulesPage,path:'/page/rule/rules_page'),
    AutoRoute(page:DeviceInfoPage,path:'/page/device/device_info/:name'),
    AutoRoute(page:DeviceAddPage,path:'/page/device/device_add'),
    AutoRoute(page:ServiceInfoPage,path:'/page/device/service_info/:name'),
    AutoRoute(page:ProfileInfoPage,path:'/page/device/profile_info/:name'),
    AutoRoute(page:SubInfoPage,path:'/page/notification/sub_info/:id'),
    AutoRoute(page:NotificationInfoPage,path:'/page/notification/notification_info/:slug'),
    AutoRoute(page:SubAddPage,path:'/page/notification/subscription_add'),
  ],
    routesClassName: 'Routes',
    transitionsBuilder: getTransitions,
    durationInMilliseconds: 800
)

class $RouterMap {}

/// 页面切换动画
Widget getTransitions(BuildContext context, Animation<double> animation1,
    Animation<double> animation2, Widget child) {
    return SlideTransition(
        position: Tween<Offset>(
            //1.0为右进右出，-1.0为左进左出
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0))
            .animate(
            CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
        child: child,
    );
}