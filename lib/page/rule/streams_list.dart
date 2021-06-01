import 'dart:async';

import "package:flutter/material.dart";
import "package:flutter_app/http.dart";
import "package:flutter_app/router/route_map.gr.dart";
import "package:flutter_app/router/router.dart";
import 'package:flutter_app/widget/general_list.dart';
import 'package:provider/provider.dart';

class StreamListPage extends StatefulWidget {
  const StreamListPage({Key key}) : super(key: key);

  @override
  _StreamListPageState createState() => _StreamListPageState();
}

class _StreamListPageState extends State<StreamListPage> {
  final StreamController<List<String>> _streamController = StreamController();

  final List<String> _selectedToDelete = [];
  @override
  void initState() {
    super.initState();
    _initStreamNameList();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  //刚进入页面时初始化数据
  void _initStreamNameList() async {
    try {
      _getStreamNameList().then((value) {
        _streamController.sink.add(List.from(value));
      }).catchError((error) {
        _streamController.sink.addError(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> _getFakeStreams() async {
    return Future.delayed(
        Duration(seconds: 2),
        () => [
              {
                "name": "name1",
                "details": {"sql": "create stream demo()"}
              },
              {"name": "name2", "details": "detail"}
            ]);
  }

  Future<List<String>> _getStreamNameList() async {
    List<String> streamNameList;
    Future<List<String>> futureResult;
    await MyHttp.get('/rule-engine/streams').then((value) {
      futureResult = Future<List<String>>.value(List.from(value));
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
          children: <Widget>[
            ListTile(
              leading: Text("#"),
              title: Text(
                "名称",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          print(_selectedToDelete);
                          for (String streamName in _selectedToDelete) {
                            print('开始删除${streamName}');
                            await MyHttp.delete(
                                    '/rule-engine/streams/${streamName.toString()}')
                                .catchError((error) {
                              print(error);
                              print(error.response);

                              showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("错误提示"),
                                      content: Text(error.response.toString()),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text("确认"))
                                      ],
                                    );
                                  });
                            });
                            print('结束删除${streamName}');
                          }
                          /*
                          await _selectedToDelete.forEach((streamName) async {
                            await MyHttp.delete(
                                    '/rule-engine/streams/${streamName.toString()}')
                                .catchError((error) {
                              
                            });
                          });
                          */
                          List<String> data = await _getStreamNameList();
                          _streamController.sink.add(data);
                          _selectedToDelete.clear();
                        }),
                    Expanded(
                      child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            MyRouter.pushAndDo(Routes.streamsAddPage,
                                (value) async {
                              print("returnback");
                              List<String> data = await _getStreamNameList();
                              _streamController.sink.add(data);
                            });
                          }),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<List<String>>(
                stream: _streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Text(
                        "目前没有流，请创建新的流",
                      );
                    } else {
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
                                          value: _selectedToDelete.contains(
                                              snapshot.data[index].toString()),
                                          onChanged: (isSelected) {
                                            print('onchanged');

                                            if (isSelected) {
                                              _selectedToDelete.add(snapshot
                                                  .data[index]
                                                  .toString());
                                            } else {
                                              _selectedToDelete.remove(snapshot
                                                  .data[index]
                                                  .toString());
                                            }
                                            setState(() {});
                                          }),
                                      title: Text(
                                        "${snapshot.data[index].toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                          //TODO: 跳转到流修改页面
                                          print(snapshot.data[index]);
                                          MyRouter.push(
                                            Routes.streamInfoPage(
                                                name: snapshot.data[index]
                                                    .toString()),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return Text(
                      "未搜索到结果，请刷新页面或检查网络连接情况",
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
                })
          ],
        ),
      ),
      onRefresh: () async {
        List<String> data = await _getStreamNameList();
        _streamController.sink.add(data);
        return Future.value();
      },
    );
  }
}

class Test extends GeneralListWidget {
  Test(String text) : super(text);
}
