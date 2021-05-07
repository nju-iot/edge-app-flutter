import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';

class NotificationInfoPage extends StatefulWidget{
  final String slug;
  NotificationInfoPage(@PathParam('slug') this.slug);

  @override
  _NotificationInfoPageState createState() => _NotificationInfoPageState();
}

class _NotificationInfoPageState extends State<NotificationInfoPage>{
  
  var noticeInfo;
  Future _future;
  
  @override
  void initState(){
    _future = MyHttp.get('/support-notification/api/v1/notification/slug/${widget.slug}');
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("提醒消息"),
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
                            MyHttp.delete('/support-notification/api/v1/notification/slug/${widget.slug}');
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
          if(snapshot.hasData) {
            noticeInfo = snapshot.data;
            String createdTime = DateTime.fromMillisecondsSinceEpoch(noticeInfo['created']).toString();
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
                                text:noticeInfo['id'],
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
                                  text:"slug: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['slug'],
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
                                  text:noticeInfo['description'],
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
                                  text:noticeInfo['labels']==null?'无':noticeInfo['labels'].toString().substring(1,noticeInfo['labels'].toString().length-1),
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
                    ),
                    Container(
                      padding:EdgeInsets.all(16.0),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text("详细信息",style:TextStyle(color:Colors.green,fontWeight:FontWeight.bold,fontSize: 16)),
                          Text.rich(TextSpan(
                              children:[
                                TextSpan(
                                  text:"发送方: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['sender'],
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
                                  text:"所属目录: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['category'],
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
                                  text:"详细内容: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['content'],
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
                                  text:"状态: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['status'],
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
                                  text:"严重等级: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['severity'],
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
                                  text:"发送方: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:noticeInfo['sender'],
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
                )
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