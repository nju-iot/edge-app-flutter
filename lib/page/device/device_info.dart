
import 'dart:convert';

import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/device/device_add.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var tmp;
class DeviceInfoPage extends StatefulWidget{
  final String name;
  
  //DeviceInfoPage({Key key,@PathParam('name') this.name}):super(key:key);
  DeviceInfoPage({@PathParam('name') this.name});

  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage>{

  //var tmp;
  Map<String,dynamic> postTmp;
  Map<String,dynamic> allProtocols = {
      "mqtt": {
        "ClientId": "clientid",
        "Host": "localhost",
        "Password": "",
        "Port": "1883",
        "Schema": "tcp",
        "Topic": "topic",
        "User": ""
      },
    "modbus-tcp": {
      "Address": "/tmp/slave",
      "Port": "1502",
      "UnitID": "1"
    },
    "modbus-rtu": {
      "Address": "/tmp/slave",
      "BaudRate": "19200",
      "DataBits": "8",
      "Parity": "N",
      "StopBits": "1",
      "UnitID": "1"
    },
    "HTTP": {
      "Address": "192.168.1.1"
    },
    "other": {}
  };

  Future<dynamic> _future;
  //Future<dynamic> _futureOfServices;
  //Future<dynamic> _futureOfProfiles;

  @override
  void initState(){

    _future = MyHttp.get('http://47.102.192.194:48081/api/v1/device/name/${widget.name}');
    //_futureOfServices = MyHttp.get('http://47.102.192.194:48081/api/v1/deviceservice');
    //_futureOfProfiles = MyHttp.get('http://47.102.192.194:48081/api/v1/deviceprofile');

    super.initState();
  }

  @override
  Widget build(BuildContext context){

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void _forSubmitted(){
      var _form = formKey.currentState;

      if (_form.validate()) {
        postTmp['adminState'] = tmp['adminState'];
        postTmp['operatingState'] = tmp['operatingState'];
        postTmp['protocols'] = tmp['protocols'];
        postTmp['service']['name'] = tmp['service']['name'];
        postTmp['profile']['name'] = tmp['profile']['name'];//不属于表单的数据也和表单一起，封装提交
        MyHttp.putJson('http://47.102.192.194:48081/api/v1/device',postTmp).catchError((error){
          print(error);
          return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: Text('修改失败，请检查网络状况或设备信息格式'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('确认'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              }
          );
        });
        _form.save();
        Navigator.of(context).pop(true);
      }
    }

    return Scaffold(
      appBar:AppBar(
        title:Text("设备详情"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('提示'),
                        content: Text('是否要删除该设备？'),
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
                              MyHttp.delete('http://47.102.192.194:48081/api/v1/device/name/${widget.name}');
                              MyRouter.push(Routes.devicePage);
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
      floatingActionButton: new FloatingActionButton(
        onPressed: _forSubmitted,
        child: new Text('提交'),
      ),
        body:FutureBuilder(
            future:_future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                tmp = snapshot.data;
                postTmp = {
                  'name':tmp['name'],
                  'id':tmp['id'],
                  'description':tmp['description'],
                  'labels':tmp['labels'],
                  'adminState':tmp['adminState'],
                  'operatingState':tmp['operatingState'],
                  "service": {
                    "name": tmp['service']['name'],
                  },
                  "profile": {
                    "name": tmp['profile']['name'],
                  },
                  "protocols": tmp['protocols']
                };

                var adminState = tmp['adminState']=="UNLOCKED"?"解锁":"锁定";
                var operatingState= tmp['operatingState']=="ENABLED"?"可操作":"不可操作";
                var currentProtocol = tmp['protocols'].keys.toString();
                currentProtocol = currentProtocol.substring(1,currentProtocol.length-1);

                return ListView(
                    children:<Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          Container(
                              padding:EdgeInsets.all(16.0),
                              child:Form(
                                key:formKey,
                                autovalidate: true,
                                child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:<Widget>[
                                      Text("基本信息",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                                      SizedBox(height:10),
                                      TextFormField(
                                        decoration:InputDecoration(
                                          //contentPadding: EdgeInsets.all(10.0),
                                          labelText: "设备名称",
                                          labelStyle: TextStyle(color:Colors.black),
                                        ),
                                        style: TextStyle(color:Colors.grey),
                                        initialValue: tmp['name'],
                                        enabled: false,
                                      ),
                                      TextFormField(
                                        decoration:InputDecoration(
                                          //contentPadding: EdgeInsets.all(10.0),
                                          labelText:"设备id",
                                          labelStyle: TextStyle(color:Colors.black),
                                        ),
                                        style: TextStyle(color:Colors.grey),
                                        initialValue: tmp['id'],
                                        enabled:false,
                                      ),
                                      TextFormField(
                                        decoration:InputDecoration(
                                          labelText: "设备描述",
                                          labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                                        ),
                                        initialValue: tmp['description'],
                                        onChanged: (val){
                                          postTmp['description'] = val;
                                        },
                                      ),
                                      TextFormField(
                                          decoration:InputDecoration(
                                            labelText: "设备标签",
                                            labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                                          ),
                                          initialValue: tmp['labels'].toString().substring(1,tmp['labels'].toString().length-1),
                                          onChanged:(val){
                                            List<String> li = val.split(',');
                                            for(int i=0;i<li.length;i++){
                                              li[i] = li[i].trim();
                                            }
                                            postTmp['labels'] = li;
                                          }
                                      ),
                                      SizedBox(height:10),

                                      Text("管理状态",style:TextStyle(color:Colors.black,fontSize: 14)),
                                      MyAdminInfo(tmp, adminState),

                                      Text("操作状态",style:TextStyle(color:Colors.black,fontSize: 14)),
                                      MyOperatingInfo(tmp, operatingState),

                                    ]
                                ),
                                onWillPop: () async{
                                  return await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('提示'),
                                          content: Text('是否要取消修改并退出？'),
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
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                     );
                                },
                              )
                          ),

                          //deviceService
                          Container(
                              padding:EdgeInsets.all(16.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    Text("设备服务",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                                    MyServiceInfo(tmp),
                                  ]
                              )
                          ),

                          //deviceProfile
                          Container(
                              padding:EdgeInsets.all(16.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    Text("设备描述文件",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                                    MyProfileInfo(tmp),
                                  ]
                              )
                          ),

                          //protocols
                          Container(
                              padding:EdgeInsets.all(16.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    Text("DeviceAddressable",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                                    MyProtocolInfo(currentProtocol, tmp, allProtocols),
                                  ]
                              )
                          ),

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


//每个dropdownButton的widget，与表单分离开，便于各自的状态管理，防止setState刷新整个widget的状态

class MyAdminInfo extends StatefulWidget{
  dynamic tmp;
  String adminState;
  MyAdminInfo(this.tmp,this.adminState);
  @override
  _MyAdminInfoState createState() => _MyAdminInfoState();

}

class _MyAdminInfoState extends State<MyAdminInfo>{

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:widget.adminState,
      onChanged: (String newValue) {
        setState(() {
          widget.tmp['adminState'] = newValue=="解锁"?"UNLOCKED":"LOCKED";
          widget.adminState = newValue;
        });
      },
      items: <String>['解锁','锁定']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class MyOperatingInfo extends StatefulWidget{
  dynamic tmp;
  String operatingState;
  MyOperatingInfo(this.tmp,this.operatingState);
  @override
  _MyOperatingInfoState createState() => _MyOperatingInfoState();

}

class _MyOperatingInfoState extends State<MyOperatingInfo>{

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:widget.operatingState,
      onChanged: (String newValue) {
        setState(() {
          widget.tmp['operatingState'] = newValue=="可操作"?"ENABLED":"DISABLED";
          widget.operatingState = newValue;
        });
      },
      items: <String>['可操作','不可操作']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}




class MyServiceInfo extends StatefulWidget{

  dynamic tmp;

  MyServiceInfo(this.tmp);

  @override
  _MyServiceInfoState createState() => _MyServiceInfoState();

}

class _MyServiceInfoState extends State<MyServiceInfo>{

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: MyHttp.get('http://47.102.192.194:48081/api/v1/deviceservice'),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var temp = snapshot.data;
            var tempList = new List<String>();
            for(int i=0;i<temp.length;i++){
              tempList.add(temp[i]['name'].toString());
            }

            return DropdownButton<String>(
              value:tmp['service']['name'],
              onChanged: (String newValue) {
                setState(() {
                  tmp['service']['name'] = newValue;
                });
              },
              items: tempList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          }else{
            return Text('');
          }
        }

    );
  }

}

class MyProfileInfo extends StatefulWidget{

  dynamic tmp;

  MyProfileInfo(this.tmp);

  @override
  _MyProfileInfoState createState() => _MyProfileInfoState();

}

class _MyProfileInfoState extends State<MyProfileInfo>{

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MyHttp.get('http://47.102.192.194:48081/api/v1/deviceprofile'),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var temp = snapshot.data;
            var tempList = new List<String>();
            for(int i=0;i<temp.length;i++){
              tempList.add(temp[i]['name'].toString());
            }
            return DropdownButton<String>(
              value:tmp['profile']['name'],
              onChanged: (String newValue) {
                setState(() {
                  tmp['profile']['name'] = newValue;
                });
              },
              items: tempList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          }else{
            return Text('');
          }
        }
    );
  }
}

class MyProtocolInfo extends StatefulWidget{

  String currentProtocol;
  dynamic tmp;
  dynamic allProtocols;

  MyProtocolInfo(this.currentProtocol,this.tmp,this.allProtocols);

  @override
  _MyProtocolInfoState createState() => _MyProtocolInfoState();
}

class _MyProtocolInfoState extends State<MyProtocolInfo>{
  @override
  Widget build(BuildContext context){
    return DropdownButton<String>(
      value:widget.currentProtocol,
      onChanged: (String newValue) {
        setState(() {
          widget.currentProtocol = newValue;
          widget.tmp['protocols'] = {newValue:widget.allProtocols[newValue]};
        });
      },
      items: <String>['mqtt','modbus-tcp','modbus-rtu','HTTP','other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

}