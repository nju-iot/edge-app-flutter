import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/widget/icon_with_text.dart';

class ServiceInfoPage extends StatefulWidget{
  final String serviceName;
  ServiceInfoPage(@PathParam('name')this.serviceName);
  @override
  _ServiceInfoPageState createState() => _ServiceInfoPageState();
}

class _ServiceInfoPageState extends State<ServiceInfoPage>{

  var serviceInfo;

  Future _future;

  @override
  void initState(){
    _future = MyHttp.get('/core-metadata/api/v1/deviceservice/name/${widget.serviceName}');
    //print(widget.serviceName);
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
      ),
      body:FutureBuilder(
        future:_future,
        builder:(BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            serviceInfo = snapshot.data;
            String createdTime = DateTime.fromMillisecondsSinceEpoch(serviceInfo['created']).toString();
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
                              IconText(" 基本信息",icon:Icon(Icons.info),style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
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
                                    text:serviceInfo['name'],
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
                                      text:"id: ",
                                      style:TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize:14,
                                      ),
                                    ),
                                    TextSpan(
                                      text:serviceInfo['id'],
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
                                      text:"是否锁定: ",
                                      style:TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize:14,
                                      ),
                                    ),
                                    TextSpan(
                                      text:serviceInfo['adminState']=="UNLOCKED"?"解锁":"锁定",
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
                                      text:serviceInfo['operatingState']=='ENABLED'?"可操作":"不可操作",
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
                          IconText(" 地址信息",icon:Icon(Icons.home),style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                          Text.rich(TextSpan(
                              children:[
                                TextSpan(
                                  text:"路径: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:serviceInfo['addressable']['url'],
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
                                  text:"端口: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:serviceInfo['addressable']['port'].toString(),
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
                                  text:"地址: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:serviceInfo['addressable']['address'],
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
                                  text:"协议: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:serviceInfo['addressable']['protocol'],
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
                                  text:"请求类型: ",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:14,
                                  ),
                                ),
                                TextSpan(
                                  text:serviceInfo['addressable']['method'],
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
                        children: [
                          Text("相关设备",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                          MyExpansionTile(widget.serviceName),
                        ],
                      )
                    )


                  ],
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

class MyExpansionTile extends StatelessWidget {

  String serviceName;
  MyExpansionTile(this.serviceName);

  var tmp;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
          title: Text('点击查看 '),
          leading: Icon(Icons.devices),
          backgroundColor: Colors.grey,
          children: <Widget>[
            FutureBuilder(
              future:MyHttp.get('/core-metadata/api/v1/device/servicename/${serviceName}'),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  tmp = snapshot.data;
                  return /*Expanded(
                      child:Container(
                          child:*/ListView.builder(
                            shrinkWrap: true,
                            itemCount: tmp == null ? 0 : tmp.length,
                            itemBuilder: (BuildContext context, int index){
                              return InkWell(
                                onTap: (){},
                                child:Card(
                                  child:ListTile(
                                    onTap:(){},
                                    leading:Text("#${index+1}"),
                                    title:Text("${tmp[index]['name'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text("id: ${tmp[index]['id'].toString()}"),
                                    trailing:IconButton(
                                        icon:Icon(Icons.arrow_forward_ios),
                                        onPressed:(){
                                          MyRouter.push(Routes.deviceInfoPage(name:"${tmp[index]['name'].toString()}"));
                                        }
                                    ),
                                  ),
                                ),
                              );
                            },
                          //),
                      //),
                  );
                }else{
                  return Container(
                      alignment: Alignment.topCenter,
                      child:Text("该服务下暂未挂载设备"),
                  );
                }
              },
            ),
          ],
          // 第一次显示打开的状态
          //initiallyExpanded: true,
        );
  }
}