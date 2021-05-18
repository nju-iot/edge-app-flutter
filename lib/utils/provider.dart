import 'package:flutter/material.dart';
import 'package:flutter_app/utils/SPUtils.dart';
import 'package:provider/provider.dart';

//使用Provider来做状态管理

//状态管理
class Store {
  Store._internal();

  //全局初始化
  static init(Widget child) {
    //多个Provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppTheme(getDefaultTheme())),
        ChangeNotifierProvider.value(value: AppStatus(TAB_HOME_EDGE_INDEX)),
        ChangeNotifierProvider.value(value: UserProfile(SPUtils.getUserName())),
      ],
      child: child,
    );
  }

  //获取值 of(context)  这个会引起页面的整体刷新，如果全局是页面级别的
  static T value<T>(BuildContext context, {bool listen = false}) {
    return Provider.of<T>(context, listen: listen);
  }

  //获取值 of(context)  这个会引起页面的整体刷新，如果全局是页面级别的
  static T of<T>(BuildContext context, {bool listen = true}) {
    return Provider.of<T>(context, listen: listen);
  }

  // 不会引起页面的刷新，只刷新了 Consumer 的部分，极大地缩小你的控件刷新范围
  static Consumer connect<T>({builder, child}) {
    return Consumer<T>(builder: builder, child: child);
  }
}

MaterialColor getDefaultTheme() {
  return AppTheme.materialColors[SPUtils.getThemeIndex()];
}


class AppTheme with ChangeNotifier {
  static final List<MaterialColor> materialColors = [
    Colors.blue,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.purple,
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
  ];

  MaterialColor _themeColor;

  AppTheme(this._themeColor);

  void setColor(MaterialColor color) {
    _themeColor = color;
    notifyListeners();
  }

  void changeColor(int index) {
    _themeColor = materialColors[index];
    SPUtils.saveThemeIndex(index);
    notifyListeners();
  }

  get themeColor => _themeColor;
}

//主页
const int TAB_HOME_EDGE_INDEX = 0;
//云端控制台
const int TAB_CLOUD_INDEX = 1;
//用户
const int TAB_USER_INDEX = 2;

//主页状态管理
class AppStatus with ChangeNotifier{
  int _tabIndex;

  AppStatus(this._tabIndex);

  int get tabIndex => _tabIndex;

  set tabIndex(int index){
    _tabIndex = index;
    notifyListeners();
  }
}

//用户信息，登录状态管理
class UserProfile with ChangeNotifier {
  String _userName;

  UserProfile(this._userName);

  String get userName => _userName;

  set userName(String userName) {
    _userName = userName;
    SPUtils.saveUserName(userName);
    notifyListeners();
  }
}
