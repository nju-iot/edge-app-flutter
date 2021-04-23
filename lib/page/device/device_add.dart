
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/device/device_info.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

Map<String,dynamic> postTmp;
String currentProtocol;
String currentService;
String currentProfile;


class DeviceAddPage extends StatefulWidget{
  @override
  _DeviceAddPageState createState() => _DeviceAddPageState();
}

class _DeviceAddPageState extends State<DeviceAddPage>{

  //Map<String,dynamic> postTmp;
  //var currentProtocol = 'mqtt';


  Future<dynamic> _futureOfServices;
  Future<dynamic> _futureOfProfiles;


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


  @override
  void initState(){
    _futureOfServices = MyHttp.get('http://47.102.192.194:48081/api/v1/deviceservice');
    _futureOfProfiles = MyHttp.get('http://47.102.192.194:48081/api/v1/deviceprofile');

    super.initState();
  }


  @override
  Widget build(BuildContext context){

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    //var currentProtocol = 'mqtt';
    postTmp = {
      'name':'',
      'description':'',
      'labels':[],
      'service':{},
      'profile':{},
      'adminState':'UNLOCKED',
      'operatingState':'ENABLED',
      'protocols': {
      },
    };
    var adminState = postTmp['adminState'] =='UNLOCKED'?'解锁':'锁定' ;
    var operatingState = postTmp['operatingState'] == 'ENABLED'?'可操作':'不可操作';
    currentProtocol = 'mqtt';

    void _forSubmitted(){
      var _form = formKey.currentState;
      if (_form.validate()) {
        postTmp['protocols'] = {currentProtocol:allProtocols[currentProtocol]};
        postTmp['service']['name'] = currentService;
        postTmp['profile']['name'] = currentProfile;
        MyHttp.postJson('http://47.102.192.194:48081/api/v1/device',postTmp);
        _form.save();
        //Navigator.of(context).pop(true);
        MyRouter.push(Routes.devicePage);
      }
    }


    return Scaffold(
      appBar:AppBar(
        title:Text('新增设备'),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: _forSubmitted,
        child: new Text('提交'),
      ),

      body:ListView(
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
                                labelText: "设备名称",
                                labelStyle: TextStyle(color:Colors.black),
                                hintText: "请输入名称",
                                errorText:"此为必填项",
                              ),
                              //textInputAction: TextInputAction.done,
                              onChanged: (val){
                                postTmp['name'] = val;
                              },
                            ),

                            TextFormField(
                              decoration:InputDecoration(
                                labelText: "设备描述",
                                labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                              ),

                              onChanged: (val){
                                postTmp['description'] = val;
                              },
                            ),

                            TextFormField(
                                decoration:InputDecoration(
                                  labelText: "设备标签",
                                  labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                                ),

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
                            MyAdminInfo(postTmp,adminState),
                            /*DropdownButton<String>(
                              value:adminState,
                              onChanged: (String newValue) {
                                setState(() {
                                  postTmp['adminState'] = newValue == "解锁"?"UNLOCKED":"LOCKED";
                                  adminState = newValue;
                                });
                              },
                              items: <String>['解锁','锁定']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),*/

                            Text("操作状态",style:TextStyle(color:Colors.black,fontSize: 14)),
                            MyOperatingInfo(postTmp,operatingState),
                            /*DropdownButton<String>(
                              value:operatingState,
                              onChanged: (String newValue) {
                                setState(() {
                                  postTmp['operatingState'] = newValue == "可操作"?"ENABLED":"DISABLED";
                                  operatingState = newValue;
                                });
                              },
                              items: <String>['可操作','不可操作']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),*/

                          ]
                      ),
                      onWillPop: () async{
                        return await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('提示'),
                                content: Text('是否要取消添加设备并退出？'),
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

                Container(
                    padding:EdgeInsets.all(16.0),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          Text("设备服务",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                          //MyAddService(postTmp,currentService),

                          FutureBuilder(
                              future: _futureOfServices,
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  var temp = snapshot.data;
                                  var tempList = new List<String>();
                                  for(int i=0;i<temp.length;i++){
                                    tempList.add(temp[i]['name'].toString());
                                  }
                                  //postTmp['service']['name'] = tempList[0];
                                  currentService = tempList[0];
                                  return MyAddService(postTmp, currentService,tempList);
                                }else{
                                  return Text('');
                                }
                              }
                          ),

                        ]
                    )
                ),

                Container(
                    padding:EdgeInsets.all(16.0),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          Text("设备描述文件",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),

                          FutureBuilder(
                              future: _futureOfProfiles,
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  var temp = snapshot.data;
                                  var tempList = new List<String>();
                                  for(int i=0;i<temp.length;i++){
                                    tempList.add(temp[i]['name'].toString());
                                  }
                                  currentProfile = tempList[0];
                                  return MyAddProfile(currentProfile, tmp, tempList);

                                }else{
                                  return Text('');
                                }
                              }
                          ),

                        ]
                    )
                ),

                Container(
                    padding:EdgeInsets.all(16.0),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          Text("DeviceAddressable",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                          MyAddProtocol(currentProtocol, postTmp, allProtocols)
                        ]
                    )
                ),

              ],
            )
          ]
      ),
    );
  }
}

class MyAddService extends StatefulWidget{
  String currentService;
  dynamic tmp;
  dynamic tempList;

  MyAddService(this.tmp,this.currentService,this.tempList);

  @override
  _MyAddServiceState createState() => _MyAddServiceState();

}

class _MyAddServiceState extends State<MyAddService>{

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:currentService,//widget.tmp['service']['name'],
      onChanged: (String newValue) {
        setState(() {
          currentService = newValue;
        });
      },
      items: widget.tempList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class MyAddProfile extends StatefulWidget{
  String currentProfile;
  var tmp;
  var tempList;

  MyAddProfile(this.currentProfile,this.tmp,this.tempList);

  @override
  _MyAddProfileState createState() => _MyAddProfileState();
}

class _MyAddProfileState extends State<MyAddProfile>{

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:currentProfile,
      onChanged: (String newValue) {
        setState(() {
          currentProfile = newValue;
          //postTmp['profile']['name'] = newValue;
          //print(postTmp['profile']['name']);
        });
      },
      items: widget.tempList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

}






class MyAddProtocol extends StatefulWidget{

  String currentProtocol;
  dynamic tmp;
  dynamic allProtocols;

  MyAddProtocol(this.currentProtocol,this.tmp,this.allProtocols);

  @override
  _MyAddProtocolState createState() => _MyAddProtocolState();
}

class _MyAddProtocolState extends State<MyAddProtocol>{
  @override
  Widget build(BuildContext context){
    return DropdownButton<String>(
      value:currentProtocol,
      onChanged: (String newValue) {
        setState(() {
          currentProtocol = newValue;
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