import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
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
    await MyHttp.get('/support-scheduler/api/v1/intervalaction').then((value) {
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
                      for (String actionId in _selectedToDelete) {
                        await MyHttp.delete(
                                '/support-scheduler/api/v1/intervalaction/${actionId}')
                            .catchError((error) {
                          print(error);
                          print(error.response);
                          showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("错误提示"),
                                  content: Text(error.response.toString()),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text("确认")),
                                  ],
                                );
                              });
                        });
                      }

                      List<Map<String, dynamic>> data = await _getActionList();
                      _streamController.sink.add(data);

                      _selectedToDelete.clear();
                    },
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        MyRouter.push(Routes.intervalActionsAddPage);
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
                                    _selectedToDelete.add(
                                        snapshot.data[index]["id"].toString());
                                  } else {
                                    _selectedToDelete.remove(
                                        snapshot.data[index]['id'].toString());
                                  }
                                  setState(() {});
                                },
                                value: _selectedToDelete.contains(
                                    snapshot.data[index]['id'].toString()),
                              ),
                              title: Text(
                                "${snapshot.data[index]['name']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("${snapshot.data[index]['id']}"),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                onPressed: () {
                                  //TODO: 跳转到行动修改页面
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
