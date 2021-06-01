import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/page_index.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/routes/cloud_route.dart';
import 'package:flutter_app/routes/user_route.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:flutter_app/widget/grid_item.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRoute extends StatefulWidget{
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

///主界面,暂时先这样
class _HomeRouteState extends State<HomeRoute>{
  String dropDownValue = '服务器1';

  @override
  Widget build(BuildContext context){
    Future<Null> _onrefresh(){
      return Future.delayed(Duration(seconds: 3),(){   // 延迟3s完成刷新
        setState(() {
          //itemCount = 10;
        });
      });
    }
    return RefreshIndicator(
        child: _buildBody(context),
        onRefresh: _onrefresh,
    );
  }

  Widget _buildBody(BuildContext context){
    MaterialColor buttonColor = Theme.of(context).primaryColor;
    final List<FunctionPageItem> funcs = [
      FunctionPageItem("设备服务", Colors.grey[200], Icon(Icons.devices,size:36,color:buttonColor[300]), Routes.devicePage),
      FunctionPageItem("消息管理", Colors.grey[200], Icon(Icons.mail_outline,size:36,color:buttonColor[300]), Routes.noticePage),
      FunctionPageItem("定时任务", Colors.grey[200], Icon(Icons.timer_outlined,size:36,color:buttonColor[300]), Routes.intervalPage),
      FunctionPageItem("规则引擎", Colors.grey[200], Icon(Icons.rule,size:36,color:buttonColor[300]), Routes.rulesPage),
    ];

    return Container(
      color:Colors.white,
      child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[

        //先写死，实际上应该是有多台edgeX服务器的
        Container(
            width:double.infinity,
            padding:EdgeInsets.fromLTRB(8, 8, 8, 0),
            child:Card(
                color:Colors.lightBlueAccent,
                child:Container(
                  padding:EdgeInsets.all(10.0),
                  decoration:BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(buttonColor[100], BlendMode.modulate),
                        image: new AssetImage(
                            'android/app/src/main/res/drawable/bg4.jpg'),
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                      gradient:LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                        colors: <Color>[
                          Colors.lightBlueAccent,
                          Colors.lightBlueAccent[100],
                        ],
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Row(
                          children:<Widget>[
                            Container(
                              //alignment: Alignment.topLeft,
                              child:Text("当前服务器",
                                style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white70),
                              ),
                            ),
                            SizedBox(width:50.0),
                            DropdownButton<String>(
                              value: dropDownValue,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropDownValue = newValue;
                                });
                              },
                              items: <String>['服务器1', '服务器2', '服务器3', '服务器4']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                  ),
                )
            )
        ),

        //简单的数据监控，展示一部分数据，先写死
        Container(
          width:double.infinity,
          padding:EdgeInsets.all(8.0),
          child:Card(
            color:Colors.lightBlueAccent,
            child:Container(
              decoration:BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(buttonColor[200], BlendMode.modulate),
                    image: new AssetImage(
                        'android/app/src/main/res/drawable/bg3.jpg'),
                  ),
                borderRadius: BorderRadius.circular(5.0),
                gradient:LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: <Color>[
                    Colors.lightBlueAccent[400],
                    Colors.lightBlueAccent[100],
                  ],
                )
              ),
              padding:EdgeInsets.all(10.0),
              child: Column(
                children:<Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child:Text("监控",
                      style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white70),
                    ),
                  ),
                  SizedBox(height:16),
                  Row(
                    children:<Widget>[
                      Expanded(
                        child:Container(
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget>[
                                  FutureBuilder(
                                    future:MyHttp.get('/core-metadata/api/v1/device'),
                                    builder: (BuildContext context,AsyncSnapshot snapshot){
                                      if(snapshot.hasData){
                                        var tmp = snapshot.data;
                                        //print(tmp.length);
                                        return Text("${tmp.length}",style:TextStyle(fontSize: 24,color: Colors.white70));
                                      }else{
                                        return Text("0",style:TextStyle(fontSize: 24,color: Colors.white70));
                                      }
                                    },
                                  ),
                                  Text("已连接设备",style:TextStyle(color: Colors.white70)),
                                ]
                            )
                        ),
                      ),
                      Expanded(
                          child:Container(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                FutureBuilder(
                                  future:MyHttp.get('/core-metadata/api/v1/deviceservice'),
                                  builder:(BuildContext context,AsyncSnapshot snapshot){
                                    if(snapshot.hasData){
                                    var tmp = snapshot.data;
                                    return Text("${tmp.length}",style:TextStyle(fontSize: 24,color: Colors.white70));
                                  }else{
                                    return Text("0",style:TextStyle(fontSize: 24,color: Colors.white70));
                                    }
                                  }
                                ),
                                Text("设备服务", style:TextStyle(color: Colors.white70)),
                              ]
                            )
                          ),
                      ),
                      Expanded(
                          child:Container(
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    Text("0",style:TextStyle(fontSize: 24,color: Colors.white70)),
                                    Text("告警统计",style:TextStyle(color: Colors.white70)),
                                  ]
                              )
                          ),
                      ),
                    ]
                  ),
                  SizedBox(height:16),

                ]
              ),
            )
          )
        ),

        Container(
          child:Column(
            children: <Widget>[
              //以下为服务菜单
              Container(
                width:double.infinity,
                padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
                child: Text(
                  "边缘服务",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.27,
                    color: Colors.black54,
                  ),
                ),
              ),

              Container(

                  width:double.infinity,
                  //height:
                  padding:EdgeInsets.only(top:12.0,left:12.0,right:12.0,bottom:12.0),
                  child:GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.6,
                    ),
                    itemBuilder: (context,index){
                      //onTap:(){}
                      var func = funcs[index];
                      return GridItem(
                        title:func.title,
                        color: func.color,
                        icon:func.icon,
                        //aimPage: func.page,
                        onTap:(){
                          MyRouter.push(func.page);
                        },
                      );
                    },
                    shrinkWrap: true,
                    itemCount: funcs.length,
                  )
              ),
            ],
          )
        ),

      ]
      /*child:RaisedButton(
        child:Text("登录"),
      ),*/
      )
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
    return Consumer2<UserProfile,AppStatus>(
      builder:(BuildContext context, UserProfile profile,AppStatus status,Widget child){
        return Drawer(
          child:SingleChildScrollView(
            child:MediaQuery.removePadding(
              context: context,
              removeTop:true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  _buildHeader(context,profile),
                  _buildMenus(context,status,profile),
                  //Expanded(child:_buildMenus(context,status)),
                ],
              ),
            ),
          )
        );
      }
    );
  }

  Widget _buildHeader(BuildContext context,UserProfile profile){
      return GestureDetector(
        child:Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: new AssetImage(
                  'android/app/src/main/res/drawable/background2.jpg'),
            ),
          ),
          //color: Theme.of(context).primaryColor,
          child:Container(
            color:Colors.white.withOpacity(.3),
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
                  profile.userName!=null?profile.userName:"未登录",
                  overflow: TextOverflow.ellipsis,
                  style:TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color:Colors.black54,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  }

  //左侧抽屉菜单
  Widget _buildMenus(BuildContext context,AppStatus status,UserProfile profile){

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
          title:Text("登出"),
          onTap:() {
            profile.userName = null;
            MyRouter.replace(Routes.loginPage);
          },
        )
      ],
    );

  }
}

