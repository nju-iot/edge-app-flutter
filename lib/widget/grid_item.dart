
import 'package:flutter/material.dart';

///网格菜单项
class GridItem extends StatelessWidget{

  final String title;

  final Color color;

  final Icon icon;

  final GestureTapCallback onTap;

  //final String aimPage;

  const GridItem({Key key,this.title,this.color,this.icon,this.onTap}):super(key:key);


  @override
  Widget build(BuildContext context){
      return Center(
        child:Container(
            alignment: Alignment.center,
            color: color,
            child:InkWell(
                onTap:onTap,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      icon,
                      SizedBox(height:10),
                      Text(title,style:TextStyle(fontSize: 16,color: Colors.black)),
                    ]
                )
            )
        ),
      );
  }

}

class FunctionPageItem{
  final String title;
  final Color color;
  final Icon icon;
  final String page;

  const FunctionPageItem(this.title,this.color,this.icon,this.page);
}