import 'dart:convert';

import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_app/http.dart";
import 'package:flutter_app/models/MyInterval.dart';
import "package:flutter_app/router/route_map.dart";
import "package:flutter_app/router/route_map.gr.dart";

enum TargetOptions { coreCommand, customized }
enum MethodOptions { GET, POST, PUT, DELETE }

Map<String, dynamic> postData = {};

class IntervalActionsAddPage extends StatefulWidget {
  @override
  _IntervalActionsAddPageState createState() => _IntervalActionsAddPageState();
}

class _IntervalActionsAddPageState extends State<IntervalActionsAddPage> {
  List<MyInterval> _intervalList = [];
  List<DropdownMenuItem<String>> _dropDownIntervalList = [];
  List<DropdownMenuItem<TargetOptions>> _targetList = [
    DropdownMenuItem(
        value: TargetOptions.coreCommand, child: Text("core-command")),
    DropdownMenuItem(
        value: TargetOptions.customized, child: Text("customized")),
  ];
  List<DropdownMenuItem<String>> _actionList = [];

  List<DropdownMenuItem<String>> _deviceNameList = [];
  List<DropdownMenuItem<String>> _deviceActionList = [];

  TargetOptions _targetOptions;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showLoadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 26.0),
                  child: Text("正在提交"),
                ),
              ],
            ),
          );
        });
  }

  Widget _getTargetList() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: "目标",
          labelStyle: TextStyle(color: Colors.black),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        value: _targetList[0].value,
        items: _targetList,
        onChanged: (TargetOptions selected) => {
          setState(() {
            this._targetOptions = selected;
          })
        },
        onSaved: (t) {
          if (t == TargetOptions.coreCommand) {
            postData['target'] = 'core-command';
          } else {
            postData['target'] = 'customized';
          }
        },
      ),
    );
  }

  Widget _getIntervalList() {
    return FutureBuilder(
      future: MyHttp.get(':48085/api/v1/interval'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Text(
              "请求发生错误，请检查网络连接并重试",
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            );
          } else {
            _intervalList = new List<MyInterval>.from(snapshot.data
                .map((interval) => MyInterval.fromJson(interval))
                .toList());
            //_intervalList.forEach((element) { print(jsonEncode(element));});
            _dropDownIntervalList = _intervalList.map((element) {
              return DropdownMenuItem(
                  value: element.name,
                  child: ConstrainedBox(
                    child: Text(
                      element.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    constraints: BoxConstraints(maxWidth: 350),
                  ));
            }).toList();

            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "任务名称",
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                value: snapshot.data[0]['name'],
                items: _dropDownIntervalList,
                onChanged: (str) => {},
                onSaved: (str) => {postData['interval'] = str},
              ),
            );
          }
        } else {
          return Container(
              height: 64,
              padding: EdgeInsets.symmetric(horizontal: 160),
              child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: 获取任务列表以实现下拉框
    super.initState();

    _targetOptions = TargetOptions.coreCommand;
  }

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoadingDialog();
      print('验证通过');
      //TODO: 弹出加载动画
      print("表单: ${postData}");
      MyHttp.postJson(':48085/api/v1/intervalaction', postData).then((value) {
        print(value);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }).catchError((error) {
        print(error);
        print(error.response.toString());
        MyHttp.handleError(error);
        return showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("错误提示"),
                content:
                    (error as DioError).type == DioErrorType.CONNECT_TIMEOUT
                        ? Text("连接超时，请检查网络状况或重试")
                        : Text(error.response.toString()),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("确认")),
                ],
              );
            }).whenComplete(() => Navigator.of(context).pop());
      });
    } else {
      print('验证失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("新增任务行动"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _formSubmit,
        child: Icon(Icons.add),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                onSaved: (text) => {postData['name'] = text},
                validator: (str) => str != "" ? null : "名称不得为空",
                autovalidateMode: AutovalidateMode.always,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "名称",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "请输入名称"),
              ),
              _getIntervalList(),
              _getTargetList(),
              if (_targetOptions == TargetOptions.coreCommand)
                DeviceNameListWidget(),
              if (_targetOptions == TargetOptions.customized)
                TargetConfigWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceNameListWidget extends StatefulWidget {
  @override
  _DeviceNameListWidgetState createState() => _DeviceNameListWidgetState();
}

class _DeviceNameListWidgetState extends State<DeviceNameListWidget> {
  List<Map<String, dynamic>> _deviceListJson;

  //一级菜单
  List<DropdownMenuItem<String>> _deviceNameList;

  //二级菜单
  List<Map<String, dynamic>> _deviceActionNameList = [];

  //关闭二级菜单
  bool disableDropdown = true;
  String _selectedDevice;

  GlobalKey<_DeviceActionListWidgetState> dropdownKey =
      GlobalKey<_DeviceActionListWidgetState>();

  @override
  Widget build(BuildContext context) {
    print("DeviceNameListWidgetState build");
    return FutureBuilder(
      future: MyHttp.get(":48082/api/v1/device"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Text("请求发生错误，请检查网络连接并重试",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold));
          } else {
            _deviceListJson =
                new List<Map<String, dynamic>>.from(snapshot.data);
            print(_deviceListJson[0]['commands']);
            _deviceNameList = new List<DropdownMenuItem<String>>.from(
                snapshot.data.map((device) {
              String tmp = device['name'];
              //print(_deviceNameList);
              return DropdownMenuItem(value: tmp, child: Text(tmp));
            }));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: DropdownButtonFormField(
                      value: _selectedDevice,
                      validator: (value) {
                        if (value == null) {
                          return "请选择一个设备";
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                        labelText: "设备",
                        labelStyle: TextStyle(color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: _deviceNameList,
                      onChanged: (deviceName) {
                        //print("onChanged");
                        try {
                          this._deviceActionNameList.clear();
                        } catch (error) {
                          print(error);
                        }
                        List<Map<String, dynamic>> filterResult =
                            _deviceListJson
                                .where(
                                    (element) => element['name'] == deviceName)
                                .toList();
                        if (filterResult[0]['commands'] == null) {
                          return;
                        }
                        filterResult[0]['commands'].forEach((command) {
                          if (command['get'] != null) {
                            command['get']['get'] = true;
                            command['get']['name'] = command['name'];
                            _deviceActionNameList.add(command["get"]);
                          }
                          if (command['put'] != null) {
                            command['put']['put'] = true;
                            command['put']['name'] = command['name'];
                            _deviceActionNameList.add(command['put']);
                          }
                        });
                        dropdownKey.currentState
                            .updateActionList(_deviceActionNameList);
                      }),
                ),
                DeviceActionListWidget(dropdownKey),
              ],
            );
          }
        } else {
          return Container(
              height: 64,
              padding: EdgeInsets.symmetric(horizontal: 160),
              child: CircularProgressIndicator());
        }
      },
    );
  }
}

//将设备动作下拉框Widget独立出来，以避免在选择设备时刷新页面中其他组件
class DeviceActionListWidget extends StatefulWidget {
  final Key key;
  DeviceActionListWidget(this.key);

  @override
  _DeviceActionListWidgetState createState() => _DeviceActionListWidgetState();
}

class _DeviceActionListWidgetState extends State<DeviceActionListWidget> {
  GlobalKey<_TargetConfigWidgetState> targetConfigKey =
      GlobalKey<_TargetConfigWidgetState>();

  List<DropdownMenuItem<Map<String, dynamic>>> _deviceActionList = [];
  void updateActionList(List<Map<String, dynamic>> list) {
    setState(() {
      this._deviceActionList = list.map((e) {
        if (e['get'] == true) {
          return DropdownMenuItem(value: e, child: Text("${e['name']}(get)"));
        } else if (e['put'] == true) {
          return DropdownMenuItem(value: e, child: Text("${e['name']}(set)"));
        } else {}
      }).toList();
      //需要清空二级菜单的选择
    });
  }

  @override
  Widget build(BuildContext context) {
    print("deviceActionListWidget build");
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                if (_deviceActionList.length == 0) {
                  return "没有可选设备动作";
                }
                return "请选择一个设备动作";
              } else {
                return null;
              }
            },

            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: "设备动作",
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: _deviceActionList.length == 0 ? "没有可选设备动作" : "请选择一项动作",
            ),
            //如果列表为空，则预设值设null
            value: null,
            items: _deviceActionList,
            //如果disable为真，则该下拉框失效
            onChanged: (value) {
              print('onChanged');

              ///print(targetConfigKey.currentState.updateTargetConfigForm != null);
              print(value);
              try {
                print("update try");
                targetConfigKey.currentState.updateTargetConfigForm(value);
              } catch (error) {
                print(error);
              }
            },
            onSaved: (value) {},
          ),
        ),
        TargetConfigWidget(key: targetConfigKey),
      ],
    );
  }
}

//TargetConfig部分独立出来，以避免在选择方法的时候rebuild整个页面
class TargetConfigWidget extends StatefulWidget {
  Key key;
  TargetConfigWidget({this.key});

  @override
  _TargetConfigWidgetState createState() => _TargetConfigWidgetState();
}

class _TargetConfigWidgetState extends State<TargetConfigWidget> {
  List<DropdownMenuItem<MethodOptions>> _methodList = [
    DropdownMenuItem(value: MethodOptions.GET, child: Text("GET")),
    DropdownMenuItem(value: MethodOptions.POST, child: Text("POST")),
    DropdownMenuItem(value: MethodOptions.PUT, child: Text("PUT")),
    DropdownMenuItem(
      value: MethodOptions.DELETE,
      child: Text("DELETE"),
    ),
  ];

  MethodOptions _methodOptions = MethodOptions.GET;

  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _portTextController = TextEditingController();
  TextEditingController _pathTextController = TextEditingController();
  TextEditingController _parametersTextController = TextEditingController();

  void updateTargetConfigForm(Map<String, dynamic> json) {
    print('updateTargetConfigForm');

    setState(() {
      if (json["get"] == true) {
        _methodOptions = MethodOptions.GET;
      } else if (json["put"] == true) {
        _methodOptions = MethodOptions.PUT;
        if (json['parameterNames'] != null) {
          _parametersTextController.text = "{\n";

          json['parameterNames'].forEach((p) {
            _parametersTextController.text =
                _parametersTextController.text + '"' + p + '"' + ':"",\n';
          });
          _parametersTextController.text = _parametersTextController.text + "}";
        }
      }
      Uri url = Uri.parse(json['url']);
      _addressTextController.text = url.host;
      _portTextController.text = url.port.toString();
      _pathTextController.text = url.path;
    });
    print("updateTargetConfigForm finish");
  }

  @override
  void initState() {
    super.initState();
    print("TargetConfigWidget initState");
  }

  @override
  Widget build(BuildContext context) {
    print("TargetConfigWidget build");
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
            new Border.all(color: Theme.of(context).primaryColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "TargetConfig",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20.0),
            ),
          ),
          TextFormField(
            onSaved: (method) => postData['protocol'] = "http",
            enabled: false,
            initialValue: "HTTP",
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              labelText: "协议",
              labelStyle:
                  TextStyle(color: Colors.black, backgroundColor: Colors.white),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          DropdownButtonFormField(
            onSaved: (value) {
              switch (value) {
                case MethodOptions.GET:
                  postData['httpMethod'] = "GET";
                  break;
                case MethodOptions.POST:
                  postData['httpMethod'] = "POST";
                  break;
                case MethodOptions.PUT:
                  postData['httpMethod'] = "PUT";
                  break;
                case MethodOptions.DELETE:
                  postData['httpMethod'] = "DELETE";
              }
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              labelText: "方法",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            value: _methodOptions,
            items: _methodList,
            onChanged: (v) {
              setState(() {
                _methodOptions = v;
              });
            },
          ),
          TextFormField(
            controller: _addressTextController,
            onSaved: (value) {
              postData['address'] = value;
            },
            decoration: InputDecoration(
              labelText: "地址",
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          TextFormField(
            controller: _portTextController,
            onSaved: (value) {
              if (value == "") {
                postData['port'] = null;
              } else {
                postData['port'] = int.parse(value);
              }
            },
            decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "端口"),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextFormField(
            controller: _pathTextController,
            //TODO:保存数据
            onSaved: (value) {
              postData['path'] = value;
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: "路径",
            ),
          ),
          if (_methodOptions != MethodOptions.GET)
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextFormField(
                maxLines: null,
                controller: _parametersTextController,
                onSaved: (value) {
                  postData['parameters'] = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 2.0,
                    ),
                  ),
                  labelText: "参数",
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
        ],
      ),
    );
    ;
  }
}
