import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/router/route_map.gr.dart';

enum RuleStatusAction { Start, Stop, ReStart }

class RuleListPage extends StatefulWidget {
  const RuleListPage({Key key}) : super(key: key);

  @override
  _RuleListPageState createState() => _RuleListPageState();
}

class _RuleListPageState extends State<RuleListPage> {
  StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController();

  final List<String> _selectedToDelete = [];
  @override
  void initState() {
    super.initState();
    _initRuleList();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  //刚进入页面时初始化数据
  void _initRuleList() async {
    try {
      _getRuleList().then((value) {
        _streamController.sink.add(List.from(value));
      }).catchError((error) {
        _streamController.sink.addError(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> _getFakeRules() async {
    return Future.delayed(
        Duration(seconds: 2),
        () => [
              {
                "id": "id1",
                "status": "status",
                "ruleDetails": "ruleDetails",
                "statusDetails": "statusDetails",
              },
              {
                "id": "id2",
                "status": "status",
                "ruleDetails": "ruleDetails",
                "statusDetails": "statusDetails",
              }
            ]);
  }

  Future<List<Map<String, dynamic>>> _getRuleList() async {
    Future<List<Map<String, dynamic>>> futureResult;
    await MyHttp.get(':48075/rules').then((value) {
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
                          try {
                            for (String ruleId in _selectedToDelete) {
                              print(ruleId);
                              await MyHttp.delete(
                                      ':48075/rules/${ruleId.toString()}')
                                  .catchError((error) {
                                print(error);
                                print(error.response);
                                showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("错误提示"),
                                        content:
                                            Text(error.response.toString()),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text("确认"))
                                        ],
                                      );
                                    });
                              });
                            }
                            List<Map<String, dynamic>> data =
                                await _getRuleList();
                            _streamController.sink.add(data);

                            _selectedToDelete.clear();
                          } catch (err) {
                            print(err);
                          }
                        },
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              MyRouter.pushAndDo(Routes.rulesAddPage,
                                  (_) async {
                                List<Map<String, dynamic>> data =
                                    await _getRuleList();
                                _streamController.sink.add(data);
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Text("未搜索到结果，请创建新的规则");
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
                                    onLongPress: () async {
                                      RuleStatusAction ruleStatusAction =
                                          await showDialog<RuleStatusAction>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SimpleDialog(
                                                  title: RichText(
                                                    text: TextSpan(
                                                        text: "请选择针对",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.black),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  " ${snapshot.data[index]['id']} ",
                                                              style: TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(text: "的操作"),
                                                        ]),
                                                  ),
                                                  children: <Widget>[
                                                    SimpleDialogOption(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 6),
                                                        child: const Text("启动"),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context,
                                                              RuleStatusAction
                                                                  .Start),
                                                    ),
                                                    SimpleDialogOption(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 6),
                                                        child: const Text("停止"),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context,
                                                              RuleStatusAction
                                                                  .Stop),
                                                    ),
                                                    SimpleDialogOption(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 6),
                                                        child: const Text("重启"),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context,
                                                              RuleStatusAction
                                                                  .ReStart),
                                                    ),
                                                  ],
                                                );
                                              });
                                      Future result;
                                      switch (ruleStatusAction) {
                                        case RuleStatusAction.Start:
                                          result = MyHttp.post(
                                              ':48075/rules/${snapshot.data[index]['id'].toString()}/start');
                                          break;
                                        case RuleStatusAction.Stop:
                                          result = MyHttp.post(
                                              ':48075/rules/${snapshot.data[index]['id'].toString()}/stop');
                                          break;
                                        case RuleStatusAction.ReStart:
                                          result = MyHttp.post(
                                              ':48075/rules/${snapshot.data[index]['id'].toString()}/restart');
                                          break;
                                        default:
                                          return;
                                      }

                                      result.then((value) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("成功"),
                                                content: Text(value.toString()),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text("确认")),
                                                ],
                                              );
                                            });
                                      }).catchError((error) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("错误讯息"),
                                                content:
                                                    Text("${error.response}"),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text("确认")),
                                                ],
                                              );
                                            });
                                      });
                                      print("重新获取数据");
                                      await Future.delayed(
                                          Duration(milliseconds: 500));
                                      List<Map<String, dynamic>> data =
                                          await _getRuleList();
                                      _streamController.sink.add(data);
                                      print("获取数据完成");
                                    },
                                    leading: Checkbox(
                                      value: _selectedToDelete.contains(snapshot
                                          .data[index]['id']
                                          .toString()),
                                      onChanged: (isSelected) {
                                        if (isSelected) {
                                          _selectedToDelete.add(snapshot
                                              .data[index]['id']
                                              .toString());
                                        } else {
                                          _selectedToDelete.remove(snapshot
                                              .data[index]['id']
                                              .toString());
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    title: Text(
                                      "${snapshot.data[index]['id'].toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "${snapshot.data[index]['status'].toString()}",
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: snapshot.data[index]['status'] !=
                                              'Running'
                                          ? TextStyle(color: Colors.red[300])
                                          : null,
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                          MyRouter.push(Routes.ruleInfoPage(
                                              id: snapshot.data[index]['id']
                                                  .toString()));
                                        }),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ));
                    }
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
              )
            ],
          ),
        ),
        onRefresh: () async {
          List<Map<String, dynamic>> data = await _getRuleList();
          _streamController.sink.add(data);
          return Future.value();
        });
  }
}
