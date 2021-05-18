import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/icon_with_text.dart';

import '../../http.dart';

class ProfileInfoPage extends StatefulWidget{
  final String profileName;
  ProfileInfoPage(@PathParam('name')this.profileName);
  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage>{

  var profileInfo;

  Future _future;

  @override
  void initState(){
    _future = MyHttp.get('/core-metadata/api/v1/deviceprofile/name/${widget.profileName}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar:AppBar(
        title:Text("详情"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async{
              return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('提示'),
                      content: Text('是否要删除已读信息？'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        FlatButton(
                          child: Text('确认'),
                          onPressed: () {
                            MyHttp.delete('/core-metadata/api/v1/deviceprofile/name/${widget.profileName}');
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  }
              );
            },
          ),
        ],
      ),
      body:FutureBuilder(
        future:_future,
        builder:(BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              profileInfo = snapshot.data;
              print(profileInfo);
              String createdTime = DateTime.fromMillisecondsSinceEpoch(profileInfo['created']).toString();
              return ListView(
                children:<Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Container(
                      padding:EdgeInsets.all(16.0),
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("基本信息",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                            Row(
                              children:<Widget>[
                                Text.rich(TextSpan(
                                    children:[
                                      TextSpan(
                                        text:"名称: ",
                                        style:TextStyle(
                                          color:Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:14,
                                        ),
                                      ),
                                      TextSpan(
                                        text:profileInfo['name'],
                                        style:TextStyle(
                                          color:Colors.grey,
                                          fontSize:14,
                                        ),
                                      )
                                    ]
                                )),
                              ]
                            ),
                            Text.rich(TextSpan(
                                children:[
                                  TextSpan(
                                    text:"id: ",
                                    style:TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:14,
                                    ),
                                  ),
                                  TextSpan(
                                    text:profileInfo['id'],
                                    style:TextStyle(
                                      color:Colors.grey,
                                      fontSize:14,
                                    ),
                                  )
                                ]
                            )),
                            Text.rich(TextSpan(
                                children:[
                                  TextSpan(
                                    text:"描述: ",
                                    style:TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:14,
                                    ),
                                  ),
                                  TextSpan(
                                    text:profileInfo['description'],
                                    style:TextStyle(
                                      color:Colors.grey,
                                      fontSize:14,
                                    ),
                                  )
                                ]
                            )),
                            Text.rich(TextSpan(
                                children:[
                                  TextSpan(
                                    text:"标签: ",
                                    style:TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:14,
                                    ),
                                  ),
                                  TextSpan(
                                    text:profileInfo['labels'].toString().substring(1,profileInfo['labels'].toString().length-1),
                                    style:TextStyle(
                                      color:Colors.grey,
                                      fontSize:14,
                                    ),
                                  )
                                ]
                            )),
                            Text.rich(TextSpan(
                                children:[
                                  TextSpan(
                                    text:"创建时间: ",
                                    style:TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:14,
                                    ),
                                  ),
                                  TextSpan(
                                    text:createdTime.substring(0,createdTime.length-4),
                                    style:TextStyle(
                                      color:Colors.grey,
                                      fontSize:14,
                                    ),
                                  )
                                ]
                            )),
                          ]
                      )
                    )
                  ]
                ),
                ]
              );
            }else{
              return Center(child:Text("加载失败，请刷新页面"));
            }
        }
      )

    );
  }
}