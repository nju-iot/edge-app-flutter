
import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';

class SettingPage extends StatefulWidget{
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text("设置"),
      ),
      body:SingleChildScrollView(
          child:ListBody(children:<Widget>[
            ListTile(
              leading:Icon(Icons.color_lens),
              title:Text("主题"),
              trailing:Icon(Icons.keyboard_arrow_right),
              contentPadding: EdgeInsets.only(left:20,right:10),
              onTap:(){
                MyRouter.push(Routes.themeColorPage);
              },
            ),
            ListTile(
              leading:Icon(Icons.title),
              title:Text("其他"),
              trailing:Icon(Icons.keyboard_arrow_right),
              contentPadding: EdgeInsets.only(left:20,right:10),
              onTap:(){},
            ),
          ])
      )
    );
  }
}