import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/http.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class IntervalListPage extends StatefulWidget {
  @override
  IntervalListPageState createState() => IntervalListPageState();
}

class IntervalListPageState extends State<IntervalListPage> {
  StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController();
  final List<String> _selectedToDelete = [];
  TextEditingController _searchController = TextEditingController();
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

  Future<List<Map<String, dynamic>>> _filterIntervalList(String keyword) async {
    List<Map<String, dynamic>> data = await _getIntervalList();
    try {
      List<Map<String, dynamic>> result = data
          .where((element) => (element['name'] as String).contains(keyword))
          .toList();
      return Future.value(List.from(result));
    } catch (error) {
      print(error);
    }
  }

  Future<List<Map<String, dynamic>>> _getIntervalList() async {
    List<Map<String, dynamic>> intervalList;

    await MyHttp.get(":48085/api/v1/interval").then((value) {
      intervalList = List.from(value);
    }).catchError((error) {
      MyHttp.handleError(error);
      return Future.error(error);
    });

    List<Map<String, dynamic>> actionList;
    await MyHttp.get(":48085/api/v1/intervalaction").then((value) {
      actionList = List.from(value);
    }).catchError((error) {
      MyHttp.handleError(error);
      return Future.error(error);
    });
    intervalList.forEach((interval) {
      interval['actions'] = [];
    });
    actionList.forEach((action) {
      int intervalIndex = intervalList
          .indexWhere((interval) => interval['name'] == action['interval']);
      (intervalList[intervalIndex]['actions'] as List).add(action);
    });
    print(intervalList);
    return intervalList;
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
                title: Container(
                    margin: EdgeInsets.only(left: 63),
                    child: Text("??????????????????",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                trailing: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool confirmDelete = false;
                          confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("??????"),
                                  content: Text("?????????????????????????????????????"),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text("??????")),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("??????"),
                                    ),
                                  ],
                                );
                              });
                          //?????????????????????????????????

                          List<Map<String, dynamic>> intervalList =
                              await _getIntervalList();
                          List<Map<String, dynamic>> selectedInterval =
                              intervalList
                                  .where((i) =>
                                      _selectedToDelete.contains(i['id']))
                                  .toList();
                          selectedInterval
                              .retainWhere((i) => i['actions'].length != 0);

                          if (selectedInterval.length != 0) {
                            confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("??????"),
                                    content: Text("??????????????????????????????????????????????????????????????????????"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("??????")),
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text("??????")),
                                    ],
                                  );
                                });
                          }

                          if (confirmDelete) {
                            for (String intervalId in _selectedToDelete) {
                              intervalList
                                  .firstWhere((interval) =>
                                      interval['id'] == intervalId)['actions']
                                  .forEach((a) async {
                                await MyHttp.delete(
                                        ":48085/api/v1/intervalaction/${a['id']}")
                                    .catchError((error) {
                                  print(error);
                                  print(error.response);
                                  showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("????????????"),
                                        content:
                                            Text(error.response.toString()),
                                        actions: [
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text("??????")),
                                        ],
                                      );
                                    },
                                  );
                                });
                              });
                              //?????????????????????????????????
                              await Future.delayed(Duration(milliseconds: 500));
                              await MyHttp.delete(
                                      ':48085/api/v1/interval/${intervalId}')
                                  .catchError((error) {
                                print(error);
                                print(error.response);
                                showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("????????????"),
                                        content:
                                            Text(error.response.toString()),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text("??????"))
                                        ],
                                      );
                                    });
                              });
                            }

                            List<Map<String, dynamic>> data =
                                await _getIntervalList();
                            _streamController.sink.add(data);

                            //?????????????????????
                            _selectedToDelete.clear();
                          }
                        }),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          MyRouter.pushAndDo(Routes.intervalAddPage,
                              (value) async {
                            print("return Back");
                            //???????????????????????????????????????
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
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 3.0), //??????xy????????????
                          blurRadius: 2.0, //??????????????????
                          spreadRadius: 0.5 //??????????????????
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
                              await _getIntervalList();
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
                                await _filterIntervalList(keyword);
                            _streamController.sink.add(data);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "???????????????????????????",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: _streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Material(
                            elevation: 4.0,
                            child: Container(
                                child: SingleChildScrollView(
                              child: ExpansionPanelList.radio(
                                children: snapshot.data
                                    .map<ExpansionPanelRadio>((interval) {
                                  return ExpansionPanelRadio(
                                    canTapOnHeader: true,
                                    value: interval['id'],
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        leading: Checkbox(
                                          value: _selectedToDelete.contains(
                                              interval['id'].toString()),
                                          onChanged: (isSelected) {
                                            if (isSelected) {
                                              _selectedToDelete.add(
                                                  interval['id'].toString());
                                            } else {
                                              _selectedToDelete.remove(
                                                  interval['id'].toString());
                                            }
                                            setState(() {});
                                          },
                                        ),
                                        title: Text(
                                            "${interval['name'].toString()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                          "id: ${interval['id'].toString().replaceAll("\n", "")}",
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(Icons.arrow_forward_ios),
                                            onPressed: () {
                                              Map<String, dynamic> m = interval;
                                              m['actions'] = null;
                                              MyRouter.pushAndDo(
                                                  Routes.intervalInfoPage(
                                                      id: jsonEncode(m)),
                                                  (_) async {
                                                print("return back");
                                                await Future.delayed(Duration(
                                                    milliseconds: 500));
                                                List<Map<String, dynamic>>
                                                    data =
                                                    await _getIntervalList();
                                                _streamController.sink
                                                    .add(data);
                                              });
                                            }),
                                      );
                                    },
                                    body: interval['actions'].length == 0
                                        ? ListTile(
                                            title: Container(
                                              margin: EdgeInsets.only(left: 60),
                                              child: Text(
                                                "??????????????????",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          )
                                        : ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              Widget divider = Divider(
                                                color: Colors.grey,
                                                height: 1,
                                              );
                                              return divider;
                                            },
                                            itemCount:
                                                interval['actions'].length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Color backgroundColor =
                                                  index % 2 == 0
                                                      ? Colors.grey[100]
                                                      : Colors.blue[50];
                                              return Container(
                                                height: 75,
                                                color: Colors.white,
                                                child: Container(
                                                  child: ListTile(
                                                    onTap: () {
                                                      Map<String, dynamic> m =
                                                          interval['actions']
                                                              [index];
                                                      m['path'] = m['path']
                                                          .replaceAll('/', '.');
                                                      MyRouter.pushAndDo(
                                                          Routes.actionInfoPage(
                                                              actionInfo:
                                                                  jsonEncode(
                                                                      m)),
                                                          (_) async {
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            data =
                                                            await _getIntervalList();
                                                        _streamController.sink
                                                            .add(data);
                                                      });
                                                    },
                                                    leading: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15, left: 20),
                                                      child: Text(
                                                          "${index + 1}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    title: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20, left: 10),
                                                      child: Text(
                                                          interval['actions']
                                                              [index]['name'],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    subtitle: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                          "id: ${interval['actions'][index]['id']}",
                                                          softWrap: false,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          )),
                                                    ),
                                                    trailing: IconButton(
                                                        icon:
                                                            Icon(Icons.delete),
                                                        onPressed: () async {
                                                          //TODO: ??????????????????
                                                          bool confirmDelete =
                                                              false;
                                                          confirmDelete =
                                                              await showDialog<
                                                                      bool>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "????????????"),
                                                                      content: Text(
                                                                          "???????????? ${interval['actions'][index]['name']} ??????????"),
                                                                      actions: [
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(false);
                                                                            },
                                                                            child:
                                                                                Text("??????")),
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(true);
                                                                            },
                                                                            child:
                                                                                Text("??????")),
                                                                      ],
                                                                    );
                                                                  });
                                                          if (confirmDelete) {
                                                            await MyHttp.delete(
                                                                    ':48085/api/v1/intervalaction/${interval['actions'][index]['id']}')
                                                                .catchError(
                                                                    (error) {
                                                              print(error);
                                                              print(error
                                                                  .response);
                                                              showDialog<bool>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "????????????"),
                                                                      content: Text(error
                                                                          .response
                                                                          .toString()),
                                                                      actions: <
                                                                          Widget>[
                                                                        FlatButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(true),
                                                                            child: Text("??????")),
                                                                      ],
                                                                    );
                                                                  });
                                                            });
                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                data =
                                                                await _getIntervalList();
                                                            _streamController
                                                                .sink
                                                                .add(data);
                                                          }
                                                        }),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  );
                                }).toList(),
                              ),
                            )),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return Text(
                      "??????????????????, ??????????????????????????????????????????",
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
    hint: "???????????????????????????",
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment:MediaQuery.of(context).orientation==Orientation.portrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    maxWidth: MediaQuery.of(context).orientation==Orientation.portrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query){
      //??????????????????????????????????????????
      
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
