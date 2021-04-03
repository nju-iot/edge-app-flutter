

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/page_index.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/routes/cloud_route.dart';
import 'package:flutter_app/routes/user_route.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget{
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

///主界面，还没往里面填东西
class _HomeRouteState extends State<HomeRoute>{
  int _count = 3;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:_buildBody(),
    );

    /*return Scaffold(
      /*appBar:AppBar(
        title:Text("主页"),
      ),*/
      body:_buildBody(),
      //drawer: MyDrawer(),
      /*bottomNavigationBar: BottomNavigationBar(
        items:<BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.airplay),title:Text("边缘端")),
          BottomNavigationBarItem(icon: Icon(Icons.cloud),title:Text("云端")),
          BottomNavigationBarItem(icon: Icon(Icons.account_box),title:Text("用户")),
        ],
      ),*/
    );*/
  }



  Widget _buildBody(){
    return Center(
      /*child:RaisedButton(
        child:Text("登录"),
      ),*/
    );
  }
}


///主界面的drawer
class MyDrawer extends StatelessWidget{
  const MyDrawer({
    Key key,
}):super(key:key);
  @override
  Widget build(BuildContext context){
    return Consumer<AppStatus>(
      builder:(BuildContext context, AppStatus status,Widget child){
        return Drawer(
          child:SingleChildScrollView(
            child:MediaQuery.removePadding(
              context: context,
              removeTop:true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  _buildHeader(context),
                  _buildMenus(context,status),
                  //Expanded(child:_buildMenus(context,status)),
                ],
              ),
            ),
          )
        );
      }
    );
    /*return Drawer(
      child:MediaQuery.removePadding(
          context: context,
          removeTop:true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              _buildHeader(context),
              Expanded(child:_buildMenus(context)),
            ],
          ),
      ),
    );*/
  }

  Widget _buildHeader(BuildContext context){
      return GestureDetector(
        child:Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: 40, bottom: 20),
          child:Row(
            children:<Widget>[
              Padding(
                padding:const EdgeInsets.symmetric(horizontal: 16.0),
                child:ClipOval(
                  child:Image.asset("android/app/src/main/res/drawable/amiya.jpg",//只是试一下添加图片，随便找的图
                    width:80,
                    height:80,
                  ),
                ),
              ),
              Text(
                "登录（假的）",
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  }

  Widget _buildMenus(BuildContext context,AppStatus status){
    return ListView(
      shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
      physics: NeverScrollableScrollPhysics(), //禁用滑动事件
      scrollDirection: Axis.vertical, // 水平listView

      children:<Widget>[
        ListTile(
          leading:const Icon(Icons.airplay),
          title:Text("边缘端"),
          onTap:(){
            status.tabIndex =TAB_HOME_EDGE_INDEX;
            Navigator.pop(context);
          },
          selected:status.tabIndex == TAB_HOME_EDGE_INDEX,
        ),
        ListTile(
          leading:const Icon(Icons.cloud),
          title:Text("云端"),
          onTap: () {
            status.tabIndex = TAB_CLOUD_INDEX;
            Navigator.pop(context);
          },
          selected:status.tabIndex == TAB_CLOUD_INDEX,
        ),
        ListTile(
          leading:const Icon(Icons.account_box),
          title:Text("用户"),
          onTap: () {
            status.tabIndex = TAB_USER_INDEX;
            Navigator.pop(context);
          },
          selected:status.tabIndex == TAB_USER_INDEX,
        ),
        Divider(height: 1.0, color: Colors.grey),
        ListTile(
          leading:const Icon(Icons.settings),
          title:Text("设置"),
          onTap:() {
            MyRouter.push(Routes.settingPage);
          },
        ),
        Divider(height: 1.0, color: Colors.grey),
        ListTile(
          leading: const Icon(Icons.logout),
          title:Text("登出(假的)"),
          onTap:() {},
        )
      ],
    );
  }
}