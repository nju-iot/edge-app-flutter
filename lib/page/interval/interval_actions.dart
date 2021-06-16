import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/models/MyAction.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'dart:async';

class IntervalActionsPage extends StatefulWidget {
  @override
  IntervalActionsPageState createState() => IntervalActionsPageState();
}

class IntervalActionsPageState extends State<IntervalActionsPage> {
  StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController();
  final List<String> _selectedToDelete = [];
  String _selectedIntervalName;

  @override
  void initState() {
    super.initState();
    _initActionList();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  void _initActionList() {
    try {
      _getActionList().then((value) {
        _streamController.sink.add(List.from(value));
      }).catchError((error) {
        _streamController.sink.addError(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> _getActionList() async {
    Future<List<Map<String, dynamic>>> futureResult;
    await MyHttp.get(':48085/api/v1/intervalaction').then((value) {
      futureResult = Future<List<Map<String, dynamic>>>.value(List.from(value));
    }).catchError((error) {
      MyHttp.handleError(error);
      futureResult = Future.error(error);
    });
    return futureResult;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    "过滤清单",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Text("定时任务:"),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: FutureBuilder(
                          future: MyHttp.get(":48085/api/v1/interval"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                print("Error: ${snapshot.error}");
                                return Text(
                                  "请求发生错误，请检查网络连接并重试",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                print("tack");
                                List<String> intervalNameList =
                                    (snapshot.data as List)
                                        .map<String>((e) => e['name'])
                                        .toList();
                                print(intervalNameList);
                                return DropdownButtonFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (str) =>
                                        str == null ? "请选择定时任务" : null,
                                    items: intervalNameList
                                        .map<DropdownMenuItem<String>>((e) =>
                                            DropdownMenuItem(
                                                value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (str) =>
                                        _selectedIntervalName = str);
                              }
                            } else {
                              return Container(
                                  height: 64,
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 100, right: 100, top: 30),
                  child: FlatButton(
                      color: Theme.of(context).buttonColor,
                      highlightColor: Theme.of(context).buttonColor,
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      onPressed: () async {
                        try {
                          List<Map<String, dynamic>> data =
                              await _getActionList();
                          print(data
                              .where((element) =>
                                  element['interval'] == _selectedIntervalName)
                              .toList());

                          _streamController.sink.add(data
                              .where((element) =>
                                  element['interval'] == _selectedIntervalName)
                              .toList());
                        } catch (error) {
                          print(error);
                        }
                      },
                      child: Text("确定")),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              ListTile(
                title: const Text("任务行动"),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool confirmDelete = false;
                          confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("提示"),
                                  content: Text("确定要删除选中定时任务吗?"),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text("取消")),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("确认"),
                                    ),
                                  ],
                                );
                              });
                          if (confirmDelete) {
                            for (String actionId in _selectedToDelete) {
                              await MyHttp.delete(
                                      ':48085/api/v1/intervalaction/${actionId}')
                                  .catchError((error) {
                                print(error);
                                print(error.response);
                                showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("错误提示"),
                                        content:
                                            Text(error.response.toString()),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text("确认")),
                                        ],
                                      );
                                    });
                              });
                            }

                            List<Map<String, dynamic>> data =
                                await _getActionList();
                            _streamController.sink.add(data);

                            _selectedToDelete.clear();
                          }
                        },
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            MyRouter.pushAndDo(Routes.intervalActionsAddPage,
                                (_) async {
                              List<Map<String, dynamic>> data =
                                  await _getActionList();
                              _streamController.sink.add(data);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: _streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Text("未搜索到符合的结果，请修改搜索条件或新增项目");
                    }
                    return Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    child: ListTile(
                                  leading: Checkbox(
                                    onChanged: (isSelected) {
                                      if (isSelected) {
                                        _selectedToDelete.add(snapshot
                                            .data[index]["id"]
                                            .toString());
                                      } else {
                                        _selectedToDelete.remove(snapshot
                                            .data[index]['id']
                                            .toString());
                                      }
                                      setState(() {});
                                    },
                                    value: _selectedToDelete.contains(
                                        snapshot.data[index]['id'].toString()),
                                  ),
                                  title: Text(
                                    "${snapshot.data[index]['name']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "id: ${snapshot.data[index]['id']}",
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                    ),
                                    onPressed: () {
                                      //TODO: 跳转到行动修改页面
                                      print(snapshot.data[index]);
                                      Map<String, dynamic> m =
                                          snapshot.data[index];
                                      m['path'] =
                                          m['path'].replaceAll('/', '.');

                                      MyRouter.pushAndDo(
                                          Routes.actionInfoPage(
                                              actionInfo: jsonEncode(m)),
                                          (_) async {
                                        List<Map<String, dynamic>> data =
                                            await _getActionList();
                                        _streamController.sink.add(data);
                                      });
                                    },
                                  ),
                                ));
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return Text(
                      "请求失败，请刷新页面或检查网络连接情况",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  } else {
                    return SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()));
                  }
                },
              ),
            ],
          )),
      onRefresh: () async {
        List<Map<String, dynamic>> data = await _getActionList();
        _streamController.sink.add(data);
        return Future.value();
      },
    );
  }
}
