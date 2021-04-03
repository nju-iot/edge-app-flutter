//占坑，页面多的时候，考虑弄一个页面路由映射表来管理页面
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_app/page/page_index.dart';
import 'package:flutter_app/page/settings.dart';
import 'package:flutter_app/routes/cloud_route.dart';
import 'package:flutter_app/routes/home_route.dart';
import 'package:flutter_app/routes/user_route.dart';

//页面路由映射表
@CustomAutoRouter(
  routes:<AutoRoute>[
    AutoRoute(page:IndexPage,initial: true),
    AutoRoute(page:HomeRoute),
    AutoRoute(page:CloudRoute),
    AutoRoute(page:UserRoute),
    CustomRoute(page:SettingPage,path:'/page/settings'),
  ],
    routesClassName: 'Routes',
    durationInMilliseconds: 800
)

class $RouterMap {}