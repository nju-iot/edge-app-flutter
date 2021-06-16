import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'dart:math' as math;

var tmp; //请求到的所有数据
bool searched = false; //标记是否进行筛选操作

class DeviceListPage extends StatefulWidget {
  @override
  DeviceListPageState createState() => DeviceListPageState();
}

class DeviceListPageState extends State<DeviceListPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      searched = false;
    });
  }

  var items = []; //展示搜索结果
  List<dynamic> showTmp = []; //从服务器上请求到的数据，用户可能会对其进行筛选，这是实际上要展示的数据。
  List<dynamic> tmpByPage = []; //分页展示的每页数据
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey();
    //_ScaffoldKey.currentState.openEndDrawer();
    Future<Null> _onrefresh() {
      return Future.delayed(Duration(seconds: 5), () {
        // 延迟5s完成刷新
        setState(() {
          searched = false; //重置筛选状态
          Fluttertoast.showToast(
              msg: "刷新成功",
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
              textColor: Colors.white,
              fontSize: 16.0);
        });
      });
    }

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return RefreshIndicator(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        endDrawer: MyEndDrawer(),
        floatingActionButton: Draggable(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              MyRouter.push(Routes.deviceAddPage);
            },
          ),
          feedback: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              MyRouter.push(Routes.deviceAddPage);
            },
          ),
          onDragEnd: (detail) {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: FutureBuilder(
          future: MyHttp.get('/core-metadata/api/v1/device'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              tmpByPage.clear();
              tmp = snapshot.data;
              if (searched == false) {
                //不进行筛选则展示所有结果
                showTmp.clear();
                for (int i = 0; i < tmp.length; i++) {
                  showTmp.add(tmp[i]); //把tmp的每项都赋给showTmp
                }
                /*for(int i=currentPage*6-6;i<currentPage*6;i++){
                    if(i==tmp.length)break;
                    showTmp.add(tmp[i]);
                  }*/
              }
              for (int i = currentPage * 6 - 6; i < currentPage * 6; i++) {
                if (i == showTmp.length) break;
                tmpByPage.add(showTmp[i]);
              }
              return FloatingSearchBar(
                  automaticallyImplyDrawerHamburger: false,
                  hint: '请输入设备名称',
                  scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                  transitionDuration: const Duration(milliseconds: 800),
                  transitionCurve: Curves.easeInOut,
                  physics: const BouncingScrollPhysics(),
                  axisAlignment: isPortrait ? 0.0 : -1.0,
                  openAxisAlignment: 0.0,
                  maxWidth: isPortrait ? 600 : 500,
                  debounceDelay: const Duration(milliseconds: 500),
                  onQueryChanged: (query) {
                    //搜索内容改变时，展示推荐结果
                    items = [];
                    if (query != null && query != '') {
                      for (int i = 0; i < tmp.length; i++) {
                        String name = tmp[i]['name'].toLowerCase();
                        if (name.contains(query.toLowerCase())) {
                          items.add(tmp[i]);
                        }
                      }
                    }
                    setState(() {});
                    // Call your model, bloc, controller here.
                  },
                  onSubmitted: (query) {
                    //展示最终搜索结果
                    items = [];
                    if (query != null && query != '') {
                      for (int i = 0; i < tmp.length; i++) {
                        String name = tmp[i]['name'].toLowerCase();
                        if (name.contains(query.toLowerCase())) {
                          items.add(tmp[i]);
                        }
                      }
                    }
                    setState(() {});
                  },
                  // Specify a custom transition to be used for
                  // animating between opened and closed stated.
                  transition: CircularFloatingSearchBarTransition(),
                  actions: [
                    //搜索栏按钮
                    Builder(builder: (context) {
                      return FloatingSearchBarAction(
                        showIfOpened: false,
                        child: CircularButton(
                          icon: const Icon(Icons.sort),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      );
                    }),
                    FloatingSearchBarAction.searchToClear(
                      showIfClosed: false,
                    ),
                  ],

                  //筛选菜单，通过简单模糊匹配，提供搜索结果
                  builder: (context, transition) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: Container(
                            height: 400.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: items == null ? 0 : items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {},
                                  title: Text(
                                      "${items[index]['name'].toString()}"),
                                  trailing: IconButton(
                                      icon:
                                          Icon(Icons.drive_file_rename_outline),
                                      onPressed: () {
                                        MyRouter.push(Routes.deviceInfoPage(
                                            name:
                                                "${items[index]['name'].toString()}"));
                                      }),
                                );
                              },
                            )),
                      ),
                    );
                  },
                  body: IndexedStack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 60.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.arrow_left,
                                      color: currentPage > 1
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey),
                                  onPressed: () {
                                    if (currentPage > 1) {
                                      currentPage -= 1;
                                      setState(() {});
                                    }
                                  }),
                              Text("上一页"),
                              SizedBox(width: 20),
                              Text(
                                  "第${currentPage}/${(showTmp.length % 6 == 0 ? showTmp.length / 6 : showTmp.length / 6 + 1).toInt()}页"),
                              SizedBox(width: 20),
                              Text("下一页"),
                              IconButton(
                                  icon: Icon(Icons.arrow_right,
                                      color: currentPage < showTmp.length / 6
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey),
                                  onPressed: () {
                                    if (currentPage < showTmp.length / 6) {
                                      currentPage += 1;
                                      setState(() {});
                                    }
                                  }),
                            ],
                          ),
                          Expanded(
                              child: Container(
                                  //margin:const EdgeInsets.only(top:70.0),
                                  child: ListView.builder(
                            itemCount: tmpByPage == null ? 0 : tmpByPage.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  child: ListTile(
                                    onTap: () {},
                                    leading: Text(
                                        "${currentPage * 6 - 6 + index + 1}"),
                                    visualDensity:
                                        VisualDensity(horizontal: -4),
                                    title: Text(
                                        "${tmpByPage[index]['name'].toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: Text(
                                        "id: ${tmpByPage[index]['id'].toString()}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    trailing: IconButton(
                                        icon: Icon(
                                            Icons.drive_file_rename_outline),
                                        onPressed: () {
                                          MyRouter.push(Routes.deviceInfoPage(
                                              name:
                                                  "${tmpByPage[index]['name'].toString()}"));
                                        }),
                                  ),
                                ),
                              );
                            },
                          ))),
                        ],
                      )
                    ],
                  ));
            } else {
              return Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 70.0),
                  child: Text("未搜索到结果，请刷新页面或重试"));
            }
          },
        ),
      ),
      onRefresh: _onrefresh,
    );
  }

  //过滤菜单
  Widget MyEndDrawer() {
    return Drawer(
      child: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.fromLTRB(
                      10,
                      MediaQueryData.fromWindow(window).padding.top + 10,
                      0,
                      10),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Text(
                    '筛选菜单',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('排序方式',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Wrap(
                            spacing: 5, //主轴上子控件的间距
                            runSpacing: 5, //交叉轴上子控件之间的间距
                            children: [
                              DropdownButton<String>(
                                value: sortType,
                                onChanged: (String newValue) {
                                  setState(() {
                                    sortType = newValue;
                                  });
                                },
                                items: <String>[
                                  '无',
                                  '按创建时间',
                                  '按设备定位'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              DropdownButton<String>(
                                value: sortOrder,
                                onChanged: (String newValue) {
                                  setState(() {
                                    sortOrder = newValue;
                                  });
                                },
                                items: <String>[
                                  '降序',
                                  '升序'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ] //要显示的子控件集合
                            ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('是否锁定',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: FilterItems(adminFilters, adminSelects),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('状态',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: FilterItems(operateFilters, operateSelects),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('协议类型',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children:
                              FilterItems(protocolFilters, protocolSelects),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
            Positioned(
              bottom: 20,
              child: Container(
                padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _onResetFilter();
                          Navigator.pop(context);
                        },
                        child: Text('重置')),
                    Container(
                      width: 20,
                    ),
                    FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _onConfirmFilter();
                          Navigator.pop(context);
                        },
                        child: Text('确定'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //需要筛选的参数
  //List<FilterModel> sortFilters = [FilterModel('创建时间',false),FilterModel('位置',false)];
  List<FilterModel> adminFilters = [
    FilterModel('解锁', false),
    FilterModel('锁定', false)
  ];
  List<FilterModel> operateFilters = [
    FilterModel('可操作', false),
    FilterModel('不可操作', false)
  ];
  List<FilterModel> protocolFilters = [
    FilterModel('mqtt', false),
    FilterModel('modbus-tcp', false),
    FilterModel('modbus-rtu', false),
    FilterModel('HTTP', false),
    FilterModel('other', false)
  ];
  //临时存放当前选中的所有类型的筛选标签
  List<String> adminSelects = [];
  List<String> operateSelects = [];
  List<String> protocolSelects = [];
  String sortType = '无';
  String sortOrder = '降序';

  //过滤菜单每一项的样式
  List<Widget> FilterItems(List<dynamic> filters, List<String> selects) {
    // print(filters);
    return List.generate(filters.length, (index) {
      var item = filters[index];
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1.0),
              color: item.isCheck
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Text('${item.title}'),
          ),
        ),
        onTap: () {
          item.isCheck = !item.isCheck;
          if (item.isCheck == true) {
            selects.add(item.title);
            //print(adminSelects);
          } else {
            selects.remove(item.title);
          }
          setState(() {});
        },
      );
    });
  }

  //提交筛选选项
  void _onConfirmFilter() {
    showTmp.clear();
    print(tmp.length);
    for (int i = 0; i < tmp.length; i++) {
      var adminAdd = false;
      if (adminSelects.length == 0) {
        adminAdd = true;
      }
      var adminState = tmp[i]['adminState'] == 'LOCKED' ? '锁定' : '解锁';
      if (adminSelects.contains(adminState)) {
        adminAdd = true;
      }
      var operateAdd = false;
      if (operateSelects.length == 0) {
        operateAdd = true;
      }
      var operatingState =
          tmp[i]['operatingState'] == 'ENABLED' ? '可操作' : '不可操作';
      if (operateSelects.contains(operatingState)) {
        operateAdd = true;
      }
      var protocolAdd = false;
      if (protocolSelects.length == 0) {
        protocolAdd = true;
      }
      var currentProtocol = tmp[i]['protocols'].keys.toString();
      currentProtocol =
          currentProtocol.substring(1, currentProtocol.length - 1);
      if (protocolSelects.contains(currentProtocol)) {
        protocolAdd = true;
      }

      if (adminAdd == true && operateAdd == true && protocolAdd == true) {
        showTmp.add(tmp[i]);
      }
    }
    if (sortType == '按创建时间') {
      showTmp.sort((left, right) {
        int created1 = right['created'];
        int created2 = left['created'];
        if (sortOrder == '降序') {
          return created1.compareTo(created2);
        } else {
          return created2.compareTo(created1);
        }
      });
    }
    setState(() {
      searched = true;
      //print(showTmp.length);
    });
  }

  //重置筛选选项
  void _onResetFilter() {
    showTmp.clear();
    //重设按钮状态
    for (int i = 0; i < adminFilters.length; i++) {
      adminFilters[i].isCheck = false;
    }
    for (int i = 0; i < operateFilters.length; i++) {
      operateFilters[i].isCheck = false;
    }
    for (int i = 0; i < protocolFilters.length; i++) {
      protocolFilters[i].isCheck = false;
    }
    //重设所有筛选选项为默认值
    adminSelects.clear();
    operateSelects.clear();
    protocolSelects.clear();
    sortType = '无';
    sortOrder = '降序';
    setState(() {
      searched = false;
    });
  }
}

//封装过滤菜单项
class FilterModel {
  String title = '';
  bool isCheck = false;
  FilterModel(this.title, this.isCheck);
  @override
  String toString() {
    return {'title': title, 'isCheck': isCheck}.toString();
  }
}
