import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';

class UserRoute extends StatefulWidget{
  @override
  _UserRouteState createState() => new _UserRouteState();
}

///用户界面
class _UserRouteState extends State<UserRoute>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Column(
        children:<Widget>[
          Container(
            color:Colors.white54,
            padding:EdgeInsets.only(top: 10, bottom: 20),
            child:Row(
              children:<Widget>[
                Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 16),
                  child:ClipOval(
                    child:Image.asset("android/app/src/main/res/drawable/amiya.jpg",
                      width:60,
                      height:60,
                    ),
                  ),
                ),
                Text(
                  "登录（假的）",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color:Colors.black54,
                  ),
                ),
                //SizedBox(width:100),

                SizedBox(width:20),

                Icon(Icons.keyboard_arrow_right),

              ]
            )
          ),

          SizedBox(height:10),

          Divider(height: 1.0, color: Colors.grey),

          //Divider(height: 1.0, color: Colors.grey),

          SingleChildScrollView(
            child:ListBody(children:<Widget>[
              ListTile(
                leading:Icon(Icons.account_circle),
                title:Text("支持与服务"),
                trailing:Icon(Icons.keyboard_arrow_right),
                contentPadding: EdgeInsets.only(left:20,right:10),
                onTap:(){},
              ),
              ListTile(
                  leading:Icon(Icons.settings),
                title:Text("设置"),
                trailing:Icon(Icons.keyboard_arrow_right),
                contentPadding: EdgeInsets.only(left:20,right:10),
                onTap:(){
                    //print(Routes.settingPage);
                    MyRouter.push(Routes.settingPage);
                },
              ),
              ListTile(
                leading:Icon(Icons.add_comment),
                title:Text("建议与反馈"),
                trailing:Icon(Icons.keyboard_arrow_right),
                contentPadding: EdgeInsets.only(left:20,right:10),
                onTap:(){},
              ),
            ])

          ),
        ],

      )
    );
  }
}