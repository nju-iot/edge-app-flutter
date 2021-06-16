import 'dart:convert';

import 'package:dio/dio.dart';
/**
 * 任务行动添加页面
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/http.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_app/models/MyAction.dart';
import 'package:flutter_app/models/MyInterval.dart';

class ActionInfoPage extends StatefulWidget {
  ActionInfoPage(@PathParam("actionInfo") String actionJsonString, {Key key})
      : super(key: key) {
    print(actionJsonString is String);
    print(actionJsonString is Map<String, dynamic>);
    actionJsonString = actionJsonString
        .replaceAll("%7B", "{")
        .replaceAll("%7D", "}")
        .replaceAll("%20", " ")
        .replaceAll("%22", '"')
        .replaceAll("%5C", '\\');
    print(actionJsonString);

    Map<String, dynamic> map = jsonDecode(actionJsonString);
    actionInfo = MyAction.fromJson(map);
    actionInfo.path = actionInfo.path.replaceAll(".", "/");
  }
  MyAction actionInfo;
  @override
  _ActionInfoPageState createState() => _ActionInfoPageState();
}

class _ActionInfoPageState extends State<ActionInfoPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String httpMethod;
  Map<String, dynamic> result = {};
  @override
  void initState() {
    super.initState();
    httpMethod = widget.actionInfo.httpMethod;
  }

  void _showLoadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text("正在提交")),
              ],
            ),
          );
        });
  }

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoadingDialog();
      print("表单验证成功");
      print(result.toString());
      MyHttp.putJson(':48085/api/v1/intervalaction', result).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }).catchError((error) {
        print(error);
        print(error.response);
        MyHttp.handleError(error);
        return showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('错误提示'),
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
    }

    //清空提交表单
    result = {};
  }

  Widget _getIntervalList() {
    return FutureBuilder(
      future: MyHttp.get(":48085/api/v1/interval"),
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
            List<String> intervalNameList = [];
            snapshot.data.forEach((e) {
              intervalNameList.add(e['name']);
            });
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: DropdownButtonFormField(
                value: widget.actionInfo.interval,
                items: intervalNameList
                    .map<DropdownMenuItem<String>>((String str) {
                  return DropdownMenuItem<String>(
                      value: str,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 350),
                        child: Text(
                          str,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
                }).toList(),
                onSaved: (str) => result['interval'] = str,
                onChanged: (str) => {},
                decoration: InputDecoration(
                  labelText: "任务名称",
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("修改任务行动"),
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
      body: RefreshIndicator(
        child: Container(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        onSaved: (str) => result['id'] = str,
                        initialValue: widget.actionInfo.id,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "id",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        onSaved: (str) => result['name'] = str,
                        initialValue: widget.actionInfo.name,
                        validator: (name) => name == "" ? "名称不得为空" : null,
                        decoration: InputDecoration(
                          labelText: "名称",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    _getIntervalList(),
                    Container(
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey[500]),
                        enabled: false,
                        onSaved: (str) => result['target'] = str,
                        initialValue: widget.actionInfo.target,
                        decoration: InputDecoration(
                          labelText: "target",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey[500]),
                        enabled: false,
                        onSaved: (str) => result['protocol'] = str,
                        initialValue: widget.actionInfo.protocol,
                        decoration: InputDecoration(
                          labelText: "protocol",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Container(
                      child: DropdownButtonFormField(
                          onSaved: (str) => result['httpMethod'] = str,
                          decoration: InputDecoration(
                            labelText: "HttpMethod",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          value: widget.actionInfo.httpMethod,
                          items: [
                            DropdownMenuItem<String>(
                                value: "GET", child: Text("GET")),
                            DropdownMenuItem<String>(
                                value: "POST", child: Text("POST")),
                            DropdownMenuItem<String>(
                                value: "PUT", child: Text("PUT")),
                            DropdownMenuItem<String>(
                                value: "DELETE", child: Text("DELETE")),
                          ],
                          onChanged: (str) {
                            setState(() {
                              this.httpMethod = str;
                            });
                          }),
                    ),
                    Container(
                      child: TextFormField(
                        onSaved: (str) => result['address'] = str,
                        validator: (str) => str == "" ? "本机地址不得为空" : null,
                        decoration: InputDecoration(
                          labelText: "address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: widget.actionInfo.address,
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        onSaved: (str) => result['port'] = int.parse(str),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (str) => str == '' ? "端口不得为空" : null,
                        decoration: InputDecoration(
                          labelText: "port",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: widget.actionInfo.port.toString(),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        onSaved: (str) => result['path'] = str,
                        validator: (str) => str == "" ? "路径不得为空" : null,
                        decoration: InputDecoration(
                          labelText: "path",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: widget.actionInfo.path,
                      ),
                    ),
                    if (this.httpMethod != "GET")
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          onSaved: (str) => result['parameters'] = str,
                          maxLines: null,
                          initialValue: widget.actionInfo.parameters,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            labelText: "paramters",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onRefresh: () {
          //TODO:
          throw UnimplementedError();
        },
      ),
    );
  }
}
