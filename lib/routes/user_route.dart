import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:provider/provider.dart';

class UserRoute extends StatefulWidget{
  @override
  _UserRouteState createState() => new _UserRouteState();
}

//用户界面
class _UserRouteState extends State<UserRoute>{
  @override
  Widget build(BuildContext context){
    MaterialColor titleColor = Theme.of(context).primaryColor;
    return Consumer<UserProfile>(
      builder:(BuildContext context, UserProfile profile,Widget child){
        return Scaffold(
            body:Column(
              children:<Widget>[
                Container(
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter:ColorFilter.mode(titleColor[100], BlendMode.modulate),
                        image: new AssetImage(
                            'android/app/src/main/res/drawable/background1.jpg'),
                      ),
                    ),
                    //color:Colors.white54,
                    child:Container(
                      color:Colors.white.withOpacity(.5),
                      padding:EdgeInsets.only(top: 10, bottom: 20),
                      child:Row(
                          children:<Widget>[
                            Padding(
                              padding:const EdgeInsets.symmetric(horizontal: 16),
                              child:ClipOval(
                                child:Image.asset("android/app/src/main/res/drawable/amiya.jpg",
                                  width:80,
                                  height:80,
                                ),
                              ),
                            ),
                            Text(
                              profile.userName!=null?profile.userName:"未登录",
                              style:TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black54,
                              ),
                            ),
                            //SizedBox(width:100),

                            SizedBox(width:20),

                            Icon(Icons.keyboard_arrow_right),

                          ]
                      )
                    )
                ),

                Divider(height: 1.0, thickness:10,color: Colors.white70),

                SizedBox(height:10),

                //Divider(height: 1.0, color: Colors.grey),

                SingleChildScrollView(
                    child:ListBody(children:<Widget>[
                      ListTile(
                        leading:Icon(Icons.account_circle,color: titleColor[300]),
                        title:Text("支持与服务"),
                        trailing:Icon(Icons.keyboard_arrow_right),
                        contentPadding: EdgeInsets.only(left:20,right:10),
                        onTap:(){},
                      ),
                      ListTile(
                        leading:Icon(Icons.settings,color: titleColor[300]),
                        title:Text("设置"),
                        trailing:Icon(Icons.keyboard_arrow_right,),
                        contentPadding: EdgeInsets.only(left:20,right:10),
                        onTap:(){
                          //print(Routes.settingPage);
                          MyRouter.push(Routes.settingPage);
                        },
                      ),
                      ListTile(
                        leading:Icon(Icons.add_comment,color: titleColor[300]),
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
    );

  }
}