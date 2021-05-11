import 'package:shared_preferences/shared_preferences.dart';


//主题颜色、登陆状态管理
class SPUtils {
  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  SPUtils._internal();

  static SharedPreferences _spf;

  static Future<SharedPreferences> init() async {
    if (_spf == null) {
      _spf = await SharedPreferences.getInstance();
    }
    return _spf;
  }

  ///主题
  static Future<bool> saveThemeIndex(int value) {
    return _spf.setInt('key_theme_color', value);
  }

  static int getThemeIndex() {
    if (_spf.containsKey('key_theme_color')) {
      return _spf.getInt('key_theme_color');
    }
    return 0;
  }

  //用户名称
  static Future<bool> saveUserName(String userName) {
    return _spf.setString('key_username', userName);
  }

  static String getUserName() {
    return _spf.getString('key_username');
  }


  //是否已登陆
  static bool isLogined() {
    String userName = getUserName();
    return userName != null && userName.isNotEmpty;
  }

}