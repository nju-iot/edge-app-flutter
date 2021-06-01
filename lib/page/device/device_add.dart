import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/device/device_info.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/widget/icon_with_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

Map<String, dynamic> postTmp;
String currentProtocol;
String currentService;
String currentProfile;

class DeviceAddPage extends StatefulWidget {
  @override
  _DeviceAddPageState createState() => _DeviceAddPageState();
}

class _DeviceAddPageState extends State<DeviceAddPage> {
  // 响应空白处的焦点的Node
  Future<dynamic> _futureOfServices;
  Future<dynamic> _futureOfProfiles;

  Map<String, dynamic> allProtocols = {
    "mqtt": {
      "ClientId": "clientid",
      "Host": "localhost",
      "Password": "",
      "Port": "1883",
      "Schema": "tcp",
      "Topic": "topic",
      "User": ""
    },
    "modbus-tcp": {"Address": "/tmp/slave", "Port": "1502", "UnitID": "1"},
    "modbus-rtu": {
      "Address": "/tmp/slave",
      "BaudRate": "19200",
      "DataBits": "8",
      "Parity": "N",
      "StopBits": "1",
      "UnitID": "1"
    },
    "HTTP": {"Address": "192.168.1.1"},
    "other": {}
  };

  @override
  void initState() {
    _futureOfServices = MyHttp.get('/core-metadata/api/v1/deviceservice');
    _futureOfProfiles = MyHttp.get('/core-metadata/api/v1/deviceprofile');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    postTmp = {
      'name': '',
      'description': '',
      'labels': [],
      'service': {},
      'profile': {},
      'adminState': 'UNLOCKED',
      'operatingState': 'ENABLED',
      'protocols': {},
    };
    var adminState = postTmp['adminState'] == 'UNLOCKED' ? '解锁' : '锁定';
    var operatingState =
        postTmp['operatingState'] == 'ENABLED' ? '可操作' : '不可操作';
    currentProtocol = 'mqtt';

    void _forSubmitted() {
      var _form = formKey.currentState;
      if (_form.validate()) {
        postTmp['protocols'] = {currentProtocol: allProtocols[currentProtocol]};
        postTmp['service']['name'] = currentService;
        postTmp['profile']['name'] = currentProfile;
        MyHttp.postJson('/core-metadata/api/v1/device', postTmp)
            .catchError((error) {
          MyHttp.handleError(error);
          return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: Text('添加失败，请检查网络状况或设备信息格式'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('确认'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              });
        }).then((value) {
          _form.save();
          Navigator.of(context).pop(true);
          setState(() {
            MyRouter.replace(Routes.devicePage);
            Fluttertoast.showToast(
                msg: "添加成功",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: appBarColor.withOpacity(.5),
                textColor: Colors.white,
                fontSize: 16.0);
          });
        });
        //MyRouter.replace(Routes.devicePage);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('新增设备'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _forSubmitted,
        child: new Text('提交'),
      ),
      body: GestureDetector(
        child: ListView(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    autovalidate: true,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 40.0),
                            child: Text("基本信息",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  labelText: "设备名称",
                                  //labelStyle: TextStyle(color:Colors.black),
                                  hintText: "此为必填项，请输入名称",
                                  hintStyle: TextStyle(fontSize: 12),
                                  icon: Icon(Icons.device_unknown)),
                              //textInputAction: TextInputAction.done,
                              onChanged: (val) {
                                postTmp['name'] = val;
                              },
                              validator: (v) {
                                if (v == null || v.length == 0) {
                                  return "此为必填项，请输入设备名称!";
                                }
                                if (v.contains(" ")) {
                                  return "设备名称中不能含有空格!";
                                }
                                return null;
                              }),
                          TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: "设备描述",
                              //labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                              hintText: "对设备的简要描述，可选",
                              hintStyle: TextStyle(fontSize: 12),
                              icon: Icon(Icons.description_outlined),
                            ),
                            onChanged: (val) {
                              postTmp['description'] = val;
                            },
                          ),
                          TextFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: "设备标签",
                                //labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                                hintText: "设备的标签，可选，标签间以英文逗号分隔",
                                hintStyle: TextStyle(fontSize: 12),
                                icon: Icon(Icons.label),
                              ),
                              onChanged: (val) {
                                List<String> li = val.split(',');
                                for (int i = 0; i < li.length; i++) {
                                  li[i] = li[i].trim();
                                }
                                postTmp['labels'] = li;
                              }),
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    IconText("是否锁定",
                                        icon: Icon(Icons.lock_open)),
                                    MyAdminInfo(postTmp, adminState),
                                    SizedBox(height: 10),
                                    IconText("状态", icon: Icon(Icons.alt_route)),
                                    MyOperatingInfo(postTmp, operatingState),
                                  ]))

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
                        ]),
                    onWillPop: () async {
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
                          });
                    },
                  )),
              Divider(height: 2.0, thickness: 1.0),
              Container(
                  padding: EdgeInsets.fromLTRB(56.0, 16.0, 16.0, 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("设备服务",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        //MyAddService(postTmp,currentService),

                        FutureBuilder(
                            future: _futureOfServices,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var temp = snapshot.data;
                                var tempList = new List<String>();
                                for (int i = 0; i < temp.length; i++) {
                                  tempList.add(temp[i]['name'].toString());
                                }
                                //postTmp['service']['name'] = tempList[0];
                                currentService = tempList[0];
                                return MyAddService(
                                    postTmp, currentService, tempList);
                              } else {
                                return Text('');
                              }
                            }),
                        SizedBox(height: 10),
                      ])),
              Container(
                  padding: EdgeInsets.fromLTRB(56.0, 16.0, 16.0, 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("设备描述文件",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        FutureBuilder(
                            future: _futureOfProfiles,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var temp = snapshot.data;
                                var tempList = new List<String>();
                                for (int i = 0; i < temp.length; i++) {
                                  tempList.add(temp[i]['name'].toString());
                                }
                                currentProfile = tempList[0];
                                return MyAddProfile(
                                    currentProfile, tmp, tempList);
                              } else {
                                return Text('');
                              }
                            }),
                        SizedBox(height: 10),
                      ])),
              Divider(height: 2.0, thickness: 1.0),
              Container(
                  padding: EdgeInsets.fromLTRB(56.0, 16.0, 16.0, 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("协议",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        MyAddProtocol(currentProtocol, postTmp, allProtocols),
                        SizedBox(height: 20),
                      ])),
            ],
          )
        ]),
      ),
    );
  }
}

class MyAddService extends StatefulWidget {
  String currentService;
  dynamic tmp;
  dynamic tempList;

  MyAddService(this.tmp, this.currentService, this.tempList);

  @override
  _MyAddServiceState createState() => _MyAddServiceState();
}

class _MyAddServiceState extends State<MyAddService> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentService, //widget.tmp['service']['name'],
      onChanged: (String newValue) {
        setState(() {
          currentService = newValue;
        });
      },
      items: widget.tempList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class MyAddProfile extends StatefulWidget {
  String currentProfile;
  var tmp;
  var tempList;

  MyAddProfile(this.currentProfile, this.tmp, this.tempList);

  @override
  _MyAddProfileState createState() => _MyAddProfileState();
}

class _MyAddProfileState extends State<MyAddProfile> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentProfile,
      onChanged: (String newValue) {
        setState(() {
          currentProfile = newValue;
          //postTmp['profile']['name'] = newValue;
          //print(postTmp['profile']['name']);
        });
      },
      items: widget.tempList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class MyAddProtocol extends StatefulWidget {
  String currentProtocol;
  dynamic tmp;
  dynamic allProtocols;

  MyAddProtocol(this.currentProtocol, this.tmp, this.allProtocols);

  @override
  _MyAddProtocolState createState() => _MyAddProtocolState();
}

class _MyAddProtocolState extends State<MyAddProtocol> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentProtocol,
      onChanged: (String newValue) {
        setState(() {
          currentProtocol = newValue;
        });
      },
      items: <String>['mqtt', 'modbus-tcp', 'modbus-rtu', 'HTTP', 'other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
