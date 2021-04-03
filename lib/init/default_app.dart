import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/page_index.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/routes/home_route.dart';
import 'package:flutter_app/utils/SPUtils.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:provider/provider.dart';


//默认APP的启动
class DefaultApp{
  static void run(){
    WidgetsFlutterBinding.ensureInitialized();
    SPUtils.init()
        .then((value) => runApp(Store.init(MyApp())));
    initApp();
  }

  //程序初始化操作
  static void initApp() {
    MyRouter.init();
    MyHttp.init();
  }

}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Consumer<AppTheme>(
      builder: (context,appTheme,_){
        return MaterialApp(
          title:'IoT',
          theme:ThemeData(
            primarySwatch: appTheme.themeColor,//主题颜色
            buttonColor: appTheme.themeColor,//按钮的填充色
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //home: IndexPage(),
          builder: ExtendedNavigator<RouterMap>(
            router:RouterMap(),//路由注册,配置见router目录
          ),
        );
      },
    );
  }
}