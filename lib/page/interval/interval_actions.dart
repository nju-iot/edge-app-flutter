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
  TextEditingController _searchController = TextEditingController();

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

  Future<List<Map<String, dynamic>>> _filterActionList(String keyword) async {
    List<Map<String, dynamic>> data = await _getActionList();
    try {
      List<Map<String, dynamic>> result = data
          .where((element) => (element['name'] as String).contains(keyword))
          .toList();
      return Future.value(List.from(result));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
          body: Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 65),
                    child: Text("任务行动",
                        style: TextStyle(fontWeight: FontWeight.bold))),
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
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 3.0), //阴影xy轴偏移量
                          blurRadius: 2.0, //阴影模糊程度
                          spreadRadius: 0.5 //阴影扩散程度
                          ),
                    ]),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () async {
                          List<Map<String, dynamic>> data =
                              await _getActionList();
                          _streamController.sink.add(data);
                          _searchController.text = "";
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (keyword) async {
                            List<Map<String, dynamic>> data =
                                await _filterActionList(keyword);
                            _streamController.sink.add(data);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入任务行动名称",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Text("未搜索到符合的结果，请修改搜索条件或新增项目");
                      }
                      return ClipRRect(
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
              ),
            ],
          ),
        ),
      )),
      onRefresh: () async {
        List<Map<String, dynamic>> data = await _getActionList();
        _streamController.sink.add(data);
        return Future.value();
      },
    );
  }
}
