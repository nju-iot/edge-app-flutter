
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/device/device_list.dart';
import 'package:flutter_app/page/device/device_profile.dart';
import 'package:flutter_app/page/device/device_service.dart';

class DevicePage extends StatefulWidget{
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState(){
    super.initState();

    _tabController = TabController(vsync:this,initialIndex: 0,length: 3);

    _tabController.addListener(() {});

    setState(() {});

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("设备管理"),
        bottom:TabBar(
          controller:_tabController,
          indicatorColor: Colors.white,
          tabs:<Widget>[
            Tab(text:"设备"),
            Tab(text:"设备服务"),
            Tab(text:"设备描述"),
          ],
        )
      ),
      body:TabBarView(
        controller:_tabController,
        children:<Widget>[
          DeviceListPage(),
          DeviceServicePage(),
          DeviceProfilePage(),
        ],
      ),

    );


    /*var tmp;
    return Scaffold(
      appBar: AppBar(
        title:Text("设备管理"),
      ),
      body:Column(
        children:<Widget>[
            Row(
              children:[
                Expanded(child:Text('')),
                Expanded(child:Text('名称')),
                Expanded(child:Text('所属服务')),
                Expanded(child:Text('操作')),
                Expanded(child:Text('')),
              ]
            ),

          FutureBuilder(
            future:MyHttp.get('http://47.102.192.194:48081/api/v1/device'),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                tmp = snapshot.data;
                print(tmp.length);
                return Expanded(
                    child:Container(
                        child:ListView.builder(
                          itemCount: tmp == null ? 0 : tmp.length,
                          itemBuilder: (BuildContext context, int index){
                            bool valued=true;
                            return InkWell(
                              onTap: (){},
                              child:ListTile(
                                  onTap:(){},
                                  leading:Checkbox(
                                    value:valued,
                                    onChanged: (bool value){
                                      setState(() {
                                        valued=value;
                                      });
                                    },
                                  ),
                                  title:Row(
                                      children:<Widget>[
                                        Expanded(child:Text("${tmp[index]['name'].toString()}")),
                                        Expanded(child:Text("${tmp[index]['service']['name'].toString()}")),
                                        Expanded(child:Icon(Icons.delete)),
                                        Expanded(child:Icon(Icons.auto_fix_high)),
                                      ]
                                  )
                              ),
                            );
                          },

                        )
                    )
                );
              }else{
                return Text("暂无数据，请添加设备");
              }
            },
          ),


            /*FutureBuilder(
              future:MyHttp.get('http://47.102.192.194:48081/api/v1/device'),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  tmp = snapshot.data;
                  print(tmp.length);
                  return Text("${tmp[1]['service']['name'].toString()}");
                }else{
                  return Text("暂无");
                }
              },
            ),*/

        ],
      )
    );*/


  }
}