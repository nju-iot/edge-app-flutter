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
  TextEditingController _searchController = TextEditingController();
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

  Future<List<Map<String, dynamic>>> _filterRuleList(String keyword) async {
    List<Map<String, dynamic>> data = await _getRuleList();
    try {
      List<Map<String, dynamic>> result = data
          .where((element) => (element['id'] as String).contains(keyword))
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
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Container(
                      margin: EdgeInsets.only(left: 20), child: Text("#")),
                  title: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "名称",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            try {
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
                                                Navigator.of(context)
                                                    .pop(false),
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
                              }
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
                                await _getRuleList();
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
                                  await _filterRuleList(keyword);
                              _streamController.sink.add(data);
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入规则名称",
                            ),
                          ),
                        ),
                      ),
                    ],
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
                                                builder:
                                                    (BuildContext context) {
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
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                                text: "的操作"),
                                                          ]),
                                                    ),
                                                    children: <Widget>[
                                                      SimpleDialogOption(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6),
                                                          child:
                                                              const Text("启动"),
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
                                                          child:
                                                              const Text("停止"),
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
                                                          child:
                                                              const Text("重启"),
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
                                                  content:
                                                      Text(value.toString()),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
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
                                                            Navigator.of(
                                                                    context)
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
                                        value: _selectedToDelete.contains(
                                            snapshot.data[index]['id']
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
        ),
        onRefresh: () async {
          List<Map<String, dynamic>> data = await _getRuleList();
          _streamController.sink.add(data);
          return Future.value();
        });
  }
}
