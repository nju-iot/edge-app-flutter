
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/provider.dart';

///学flutter的时候学着示例模板写的，以后不用的话，删改即可

class ThemeColorPage extends StatefulWidget{
  @override
  _ThemeColorPageState createState() => _ThemeColorPageState();
}

class _ThemeColorPageState extends State<ThemeColorPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text("主题色"),
      ),
      body:GridView.builder(
        padding:const EdgeInsets.all(15),
        itemCount: AppTheme.materialColors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
          childAspectRatio: 1.0
        ),
        itemBuilder: (context,index){
          return GestureDetector(
            onTap:(){
              Store.value<AppTheme>(context).changeColor(index);
            },
            child: Container(color: AppTheme.materialColors[index]),
          );
        }
      ),
    );
  }
}