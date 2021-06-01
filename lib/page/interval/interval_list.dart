import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/http.dart';

class IntervalListPage extends StatefulWidget {
  @override
  IntervalListPageState createState() => IntervalListPageState();
}

class IntervalListPageState extends State<IntervalListPage> {
  StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController();
  final List<String> _selectedToDelete = [];

  @override
  void initState() {
    super.initState();
    _initIntervalList();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  void _initIntervalList() {
    try {
      _getIntervalList().then((value) {
        _streamController.sink.add(List.from(value));
      }).catchError((error) {
        _streamController.sink.addError(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> _getIntervalList() async {
    Future<List<Map<String, dynamic>>> futureResult;
    await MyHttp.get("/support-scheduler/api/v1/interval").then((value) {
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
              title: Text("定时任务列表"),
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        for (String intervalId in _selectedToDelete) {
                          await MyHttp.delete(
                                  '/support-scheduler/api/v1/interval/${intervalId}')
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
                        }

                        List<Map<String, dynamic>> data =
                            await _getIntervalList();
                        _streamController.sink.add(data);

                        //清空待删数据组
                        _selectedToDelete.clear();
                      }),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        MyRouter.pushAndDo(Routes.intervalAddPage,
                            (value) async {
                          print("return Back");
                          //马上取后端似乎还来不及加入
                          await Future.delayed(Duration(milliseconds: 500));
                          List<Map<String, dynamic>> data =
                              await _getIntervalList();
                          print(data.length);
                          _streamController.sink.add(data);
                        });
                      },
                    ),
                  ),
                ]),
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
                                    value: _selectedToDelete.contains(
                                        snapshot.data[index]['id'].toString()),
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
                                    }),
                                onTap: () {},
                                title: Text(
                                  "${snapshot.data[index]['name'].toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    "id: ${snapshot.data[index]['id'].toString()}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    //TODO: 跳转到定时任务修改页面
                                    MyRouter.push(Routes.intervalInfoPage(
                                        id: snapshot.data[index]['id']
                                            .toString()));
                                  },
                                ),
                              ),
                            );
                          },
                        )),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Text(
                    "未搜索到结果, 请刷新页面或检查网络连接情况",
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
        List<Map<String, dynamic>> data = await _getIntervalList();
        _streamController.sink.add(data);
        return Future.value();
      },
    );
  }

  /* 
  Widget buildFloatingSearchBar(){
  return FloatingSearchBar(
    automaticallyImplyDrawerHamburger: false,
    hint: "请输入定时任务名称",
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment:MediaQuery.of(context).orientation==Orientation.portrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    maxWidth: MediaQuery.of(context).orientation==Orientation.portrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query){
      //搜索内容改变时，展示推荐结果
      
    },
    builder: (context,transition){
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Center(
            child: Text("text"),
          ),
        ),
      );
    });
  }

  */
}
