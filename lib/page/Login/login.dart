

import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  bool _isShowPassWord = false;//控制密码的显示
  FocusNode blankNode = FocusNode();
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            // leading: _leading(context),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  appBarColor[800],
                  appBarColor[200],
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
            title: Text("登录"),
            actions: <Widget>[
              FlatButton(
                child: Text("注册"),
                textColor: Colors.white,
                onPressed: () {
                 MyRouter.push(Routes.registerPage);
                },
              )
            ],
          ),
          body: GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              closeKeyboard(context);
            },
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: loginForm(context),
            ),
          ),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  Widget loginForm(BuildContext context){
    return Form(
      key:_formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          Center(
              heightFactor: 1.5,
              child: FlutterLogo(
                size: 64,
              )),
          TextFormField(
              autofocus: false,
              controller: _unameController,
              decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "请输入用户名",
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.person)),
              //校验用户名
              validator: (v) {
                return v.trim().length > 0
                    ? null
                    : "请输入用户名!";
              }),
          TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isShowPassWord
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord)),
              obscureText: !_isShowPassWord,
            //校验密码
              validator: (v) {
                return v.trim().length >= 6
                    ? null
                    : "密码长度不能少于六";
              }),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Builder(builder: (context) {
                  return RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text("登录"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (Form.of(context).validate()) {
                        _onSubmit(context);
                      }
                    },
                  );
                })),
              ],
            ),
          )
        ],
      ),

    );
  }

  //控制密码显示
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  void _onSubmit(BuildContext context){
    closeKeyboard(context);
    getPwd();
  }

  getPwd() async{
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String truePwd = prefs.get(_unameController.text);
    if(truePwd==_pwdController.text){
      userProfile.userName = _unameController.text;
      MyRouter.replace(Routes.indexPage);
      Fluttertoast.showToast(
          msg: "登录成功",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}
