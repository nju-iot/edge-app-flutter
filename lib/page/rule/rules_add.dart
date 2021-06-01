import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/http.dart';
import 'dart:async';

enum RuleAction { RestHttp, MQTT, EdgeXMessageBus }
enum TargetAction { CoreCommand, Customized }
enum HTTPMethod { GET, DELETE, PUT, POST }

class RulesAddPage extends StatefulWidget {
  const RulesAddPage({Key key}) : super(key: key);

  @override
  _RulesAddPageState createState() => _RulesAddPageState();
}

class _RulesAddPageState extends State<RulesAddPage> {
  Map<String, dynamic> resultData = {"actions": []};
  bool _sendTheResultToLogFile = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<_ActionConfigWidgetState> _actionConfigStateKey =
      GlobalKey<_ActionConfigWidgetState>();

  void _addSubmit() {
    if (_sendTheResultToLogFile) {
      if (!(resultData['actions'] as List).contains({"log": {}})) {
        resultData['actions'].add({"log": {}});
      }
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      MyHttp.postJson('/rule-engine/rules', resultData).then((value) {
        Navigator.of(context).pop();
      }).catchError((error) {
        print(error);
        print(error.response);
      });
      List<Map<String, dynamic>> result =
          _actionConfigStateKey.currentState.returnActionList();
      (resultData['actions'] as List).addAll(result);

      print("表单: ${resultData.toString()}");
    }

    resultData = {"actions": []};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增规则"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSubmit();
        },
        child: Icon(Icons.add),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 30,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    onSaved: (str) {
                      resultData['id'] = str;
                    },
                    validator: (value) => value == '' ? "id 不得为空" : null,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "ID 是唯一的标识符",
                      labelText: "ID",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    onSaved: (str) {
                      resultData['sql'] = str;
                    },
                    validator: (value) => value == '' ? "sql 不得为空" : null,
                    style: TextStyle(height: 1.5),
                    maxLines: null,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "规则 SQL，如：SELECT * FROM demo",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: "Sql",
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    children: [
                      Container(
                          child: Text("记录到日志文件",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Switch(
                          value: _sendTheResultToLogFile,
                          onChanged: (goSend) {
                            setState(() {
                              _sendTheResultToLogFile = goSend;
                            });
                          })
                    ],
                  ),
                ),
                FlatButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    onPressed: () async {
                      RuleAction ruleAction = await showDialog<RuleAction>(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text("请选择规则行动"),
                              children: <Widget>[
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, RuleAction.RestHttp);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: const Text(
                                        "Send the result to a Rest HTTP server."),
                                  ),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, RuleAction.MQTT);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: const Text(
                                        "Send the result to an MQTT broker"),
                                  ),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(
                                        context, RuleAction.EdgeXMessageBus);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: const Text(
                                        "Send the result to EdgeX message bus."),
                                  ),
                                ),
                              ],
                            );
                          });
                      switch (ruleAction) {
                        case RuleAction.RestHttp:
                          _actionConfigStateKey.currentState
                              .addRestHTTPConfig();
                          break;
                        case RuleAction.EdgeXMessageBus:
                          _actionConfigStateKey.currentState
                              .addEdgeXMessageBusConfig();
                          break;
                        case RuleAction.MQTT:
                          _actionConfigStateKey.currentState.addMQTTConfig();
                          break;
                      }
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Text("Select Actions")),
                ActionConfigWidget(
                  key: _actionConfigStateKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionConfigWidget extends StatefulWidget {
  const ActionConfigWidget({Key key}) : super(key: key);

  @override
  _ActionConfigWidgetState createState() => _ActionConfigWidgetState();
}

class _ActionConfigWidgetState extends State<ActionConfigWidget> {
  List<Widget> actionsConfigList = [];
  List<GlobalKey> _globalkeyList = [];
  List<Map<String, dynamic>> returnActionList() {
    List<Map<String, dynamic>> resultConfigList = [];
    for (GlobalKey k in _globalkeyList) {
      if (k is GlobalKey<_MQTTConfigWidgetState>) {
        resultConfigList.add(
            (k as GlobalKey<_MQTTConfigWidgetState>).currentState.returnForm());
      } else if (k is GlobalKey<_RestHTTPConfigWidgetState>) {
        resultConfigList.add(k.currentState.returnForm());
      } else if (k is GlobalKey<_EdgeXMessageBusConfigWidgetState>) {
        resultConfigList.add(k.currentState.returnForm());
      }
    }
    return resultConfigList;
  }

  void addEdgeXMessageBusConfig() {
    GlobalKey<_EdgeXMessageBusConfigWidgetState> k =
        GlobalKey<_EdgeXMessageBusConfigWidgetState>();
    this.actionsConfigList.add(EdgeXMessageBusConfigWidget(
          removeWidget,
          key: k,
        ));
    _globalkeyList.add(k);
    setState(() {});
  }

  void addMQTTConfig() {
    GlobalKey<_MQTTConfigWidgetState> k = GlobalKey<_MQTTConfigWidgetState>();
    this.actionsConfigList.add(MQTTConfigWidget(
          removeWidget,
          key: k,
        ));
    _globalkeyList.add(k);
    setState(() {});
  }

  void addRestHTTPConfig() {
    GlobalKey<_RestHTTPConfigWidgetState> k =
        GlobalKey<_RestHTTPConfigWidgetState>();

    this.actionsConfigList.add(RestHTTPConfigWidget(
          removeWidget,
          key: k,
        ));
    _globalkeyList.add(k);
    setState(() {});
  }

  void removeWidget(Widget w) {
    actionsConfigList.remove(w);
    _globalkeyList.remove(w.key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: actionsConfigList,
    );
  }
}

class EdgeXMessageBusConfigWidget extends StatefulWidget {
  EdgeXMessageBusConfigWidget(this.removeItem, {Key key}) : super(key: key);
  final Function(EdgeXMessageBusConfigWidget) removeItem;
  //TODO: 这里的值会正确的被保存，state里的却不会正确保存
  TextEditingController _protocolTextController = TextEditingController();
  TextEditingController _hostTextController = TextEditingController();
  TextEditingController _portTextController = TextEditingController();
  TextEditingController _topicTextController = TextEditingController();
  TextEditingController _contentTypeTextController = TextEditingController();
  TextEditingController _metadataTextController = TextEditingController();
  TextEditingController _deviceNameTextController = TextEditingController();
  TextEditingController _typeTextController = TextEditingController();
  TextEditingController _optionalTextController = TextEditingController();

  @override
  _EdgeXMessageBusConfigWidgetState createState() {
    print("createState");
    return _EdgeXMessageBusConfigWidgetState();
  }
}

class _EdgeXMessageBusConfigWidgetState
    extends State<EdgeXMessageBusConfigWidget> {
  List<Map<String, TextEditingController>> _inputNameAndController;
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> resultConfig = {"edgex": {}};
  Map<String, dynamic> returnForm() {
    _formKey.currentState.save();
    return resultConfig;
  }

  @override
  void initState() {
    super.initState();
    _inputNameAndController = [
      {
        "protocol": widget._protocolTextController,
        "host": widget._hostTextController,
      },
      {
        "port": widget._portTextController,
        "topic": widget._topicTextController,
      },
      {
        "contentType": widget._contentTypeTextController,
        "metadata": widget._metadataTextController,
      },
      {
        "deviceName": widget._deviceNameTextController,
        "type": widget._typeTextController,
      }
    ];
  }

  List<Widget> makeForm() {
    return _inputNameAndController.map((ent) {
      return Row(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            width: MediaQuery.of(context).size.width * 0.35,
            child: TextFormField(
              onSaved: (str) {
                resultConfig['edgex'][ent.entries.toList()[0].key] = str;
              },
              controller: ent.entries.toList()[0].value,
              decoration: InputDecoration(
                labelText: ent.entries.toList()[0].key,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: TextFormField(
                onSaved: (str) {
                  resultConfig['edgex'][ent.entries.toList()[1].key] = str;
                },
                controller: ent.entries.toList()[1].value,
                decoration: InputDecoration(
                  labelText: ent.entries.toList()[1].key,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    //print('${widget.index} build, ${widget.protocolController.text}, ${controllerB.text}');
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.only(
        top: 20,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('EdgeX Message bus'),
              trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    widget.removeItem(widget);
                  }),
            ),
            Column(
              children: makeForm(),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  bottom: 30),
              child: TextFormField(
                onSaved: (str) {
                  resultConfig['edgex']['optional'] = str;
                },
                controller: widget._optionalTextController,
                decoration: InputDecoration(
                  labelText: "optional",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MQTTConfigWidget extends StatefulWidget {
  MQTTConfigWidget(this.removeItem, {Key key}) : super(key: key);
  final Function(MQTTConfigWidget) removeItem;
  bool insecureSkipVerify = false;
  bool retained = false;
  TextEditingController _serverTextController = TextEditingController();
  TextEditingController _topicTextController = TextEditingController();
  TextEditingController _clientIdTextController = TextEditingController();
  TextEditingController _protocolVersionTextController =
      TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _cerificationPathController = TextEditingController();
  TextEditingController _privateKeyPathTextController = TextEditingController();
  TextEditingController _qosTextController = TextEditingController();

  @override
  _MQTTConfigWidgetState createState() => _MQTTConfigWidgetState();
}

class _MQTTConfigWidgetState extends State<MQTTConfigWidget> {
  List<Map<String, TextEditingController>> _inputNameAndController;
  Map<String, dynamic> resultConfig = {"mqtt": {}};
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _inputNameAndController = [
      {
        "server": widget._serverTextController,
        "topic": widget._topicTextController,
      },
      {
        "clientId": widget._clientIdTextController,
        "protocolVersion": widget._protocolVersionTextController,
      },
      {
        "username": widget._usernameTextController,
        "password": widget._passwordTextController,
      },
      {
        "certificationPath": widget._cerificationPathController,
        "privateKeyPath": widget._privateKeyPathTextController,
      }
    ];
  }

  Map<String, dynamic> returnForm() {
    _formKey.currentState.save();
    resultConfig["mqtt"]['insecureSkipVerify'] = widget.insecureSkipVerify;
    resultConfig['mqtt']['retained'] = widget.retained;
    return resultConfig;
  }

  List<Widget> makeForm() {
    return _inputNameAndController.map((ent) {
      return Row(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            width: MediaQuery.of(context).size.width * 0.35,
            child: TextFormField(
              onSaved: (str) {
                resultConfig['mqtt'][ent.entries.toList()[0].key] = str;
              },
              controller: ent.entries.toList()[0].value,
              decoration: InputDecoration(
                labelText: ent.entries.toList()[0].key,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: TextFormField(
                onSaved: (str) {
                  resultConfig['mqtt'][ent.entries.toList()[1].key] = str;
                },
                controller: ent.entries.toList()[1].value,
                decoration: InputDecoration(
                  labelText: ent.entries.toList()[1].key,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.only(
        top: 20,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('MQTT Config'),
              trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    widget.removeItem(widget);
                  }),
            ),
            Column(
              children: makeForm(),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: DropdownButtonFormField(
                      value: widget.insecureSkipVerify,
                      decoration: InputDecoration(
                        labelText: "insecureSkipVerify",
                      ),
                      items: [
                        DropdownMenuItem<bool>(
                          value: true,
                          child: Text("true"),
                        ),
                        DropdownMenuItem<bool>(
                            value: false, child: Text("false")),
                      ],
                      onChanged: (value) {
                        //取消焦点，即改变当前焦点
                        widget.insecureSkipVerify = value;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: DropdownButtonFormField(
                        value: widget.retained,
                        decoration: InputDecoration(
                          labelText: "retained",
                        ),
                        items: [
                          DropdownMenuItem<bool>(
                              value: true, child: Text("true")),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text("false"),
                          ),
                        ],
                        onChanged: (value) {
                          widget.retained = value;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        }),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  bottom: 30),
              child: TextFormField(
                controller: widget._qosTextController,
                decoration: InputDecoration(
                  labelText: "Qos",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestHTTPConfigWidget extends StatefulWidget {
  RestHTTPConfigWidget(this.removeItem, {Key key}) : super(key: key);
  final Function(RestHTTPConfigWidget) removeItem;
  TargetAction targetAction = TargetAction.CoreCommand;
  HTTPMethod httpMethod = HTTPMethod.GET;
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _portTextController = TextEditingController();
  TextEditingController _pathTextController = TextEditingController();
  TextEditingController _retryIntervalTextController = TextEditingController();
  bool sendSingle = true;
  TextEditingController _protocolTextController = TextEditingController();
  TextEditingController _parameterTextController = TextEditingController();
  @override
  _RestHTTPConfigWidgetState createState() => _RestHTTPConfigWidgetState();
}

class _RestHTTPConfigWidgetState extends State<RestHTTPConfigWidget> {
  StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> resultConfig = {"rest": {}};
  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  Future<List<Map<String, dynamic>>> _getDeviceList() async {
    List<Map<String, dynamic>> data;
    await MyHttp.get('/core-command/api/v1/device').then((value) {
      data = List.from(value);
    });
    //print(data.toString());
    return Future.value(data);
  }

  Map<String, dynamic> returnForm() {
    _formKey.currentState.save();
    return resultConfig;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.only(
        top: 20,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("RestHTTPConfig",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Target",
                    ),
                    value: widget.targetAction,
                    items: [
                      DropdownMenuItem<TargetAction>(
                          value: TargetAction.CoreCommand,
                          child: Text("core-command")),
                      DropdownMenuItem<TargetAction>(
                          value: TargetAction.Customized,
                          child: Text("customized")),
                    ],
                    onChanged: (selectedValue) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        widget.targetAction = selectedValue;
                      });
                    }),
              ),
              if (widget.targetAction == TargetAction.CoreCommand)
                Container(
                  child: FutureBuilder(
                    future: _getDeviceList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              "请求发生错误，请重试",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return Container(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: "Device",
                              ),
                              items: snapshot.data.map<DropdownMenuItem>((e) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                    value: e,
                                    child: Container(
                                      child: Text(
                                        "${e["name"].toString()}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ));
                              }).toList(),
                              onChanged: (deviceData) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                _streamController.sink.add(deviceData);
                              },
                            ),
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              if (widget.targetAction == TargetAction.CoreCommand)
                Container(
                  child: StreamBuilder(
                    stream: _streamController.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return Text("请求失败，请重试");
                        } else {
                          if (snapshot.data.length == 0) {
                            return Text("zero");
                          }
                          print("--------------StreamBuilder-----------");
                          print(snapshot.data.toString());

                          List<DropdownMenuItem<Map<String, dynamic>>>
                              dropdownItemList = [];
                          snapshot.data['commands'].forEach((e) {
                            if (e['get'] != null) {
                              e['get']['get'] = true;
                              dropdownItemList.add(DropdownMenuItem(
                                  value: e['get'],
                                  child: Text("${e['name'].toString()}(get)")));
                            }

                            if (e['put'] != null) {
                              e['put']['put'] = true;
                              dropdownItemList.add(DropdownMenuItem(
                                  value: e['put'],
                                  child: Text("${e['name'].toString()}(set)")));
                            }
                          });
                          return Container(
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: "Action",
                                ),
                                items: dropdownItemList,
                                onChanged: (Map<String, dynamic> command) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  widget._protocolTextController.text = "HTTP";
                                  Uri u = Uri.parse(command['url']);
                                  widget._portTextController.text =
                                      u.port.toString();
                                  widget._pathTextController.text =
                                      u.path.toString();
                                  widget._addressTextController.text =
                                      u.host.toString();
                                  if (command['get'] == true) {
                                    widget.httpMethod = HTTPMethod.GET;
                                  } else if (command['put'] == true) {
                                    widget.httpMethod = HTTPMethod.PUT;
                                  }
                                }),
                          );
                        }
                      } else {
                        return Container(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(labelText: "Action"),
                            items: null,
                            onChanged: null,
                          ),
                        );
                      }
                    },
                  ),
                ),
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Protocol",
                    ),
                    controller: widget._protocolTextController,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1),
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Method",
                        ),
                        value: widget.httpMethod,
                        items: [
                          DropdownMenuItem<HTTPMethod>(
                            value: HTTPMethod.GET,
                            child: const Text("GET"),
                          ),
                          DropdownMenuItem<HTTPMethod>(
                            value: HTTPMethod.POST,
                            child: const Text("POST"),
                          ),
                          DropdownMenuItem<HTTPMethod>(
                            value: HTTPMethod.PUT,
                            child: const Text("PUT"),
                          ),
                          DropdownMenuItem<HTTPMethod>(
                            value: HTTPMethod.DELETE,
                            child: const Text("DELETE"),
                          ),
                        ],
                        onChanged: (selected) {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          widget.httpMethod = selected;
                        }),
                  ),
                ),
              ]),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Address",
                      ),
                      controller: widget._addressTextController,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Port",
                        ),
                        controller: widget._portTextController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "RetryInterval"),
                      controller: widget._retryIntervalTextController,
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "SendSingle",
                            ),
                            value: widget.sendSingle,
                            items: [
                              DropdownMenuItem<bool>(
                                  value: true, child: Text("true")),
                              DropdownMenuItem(
                                  value: false, child: Text("false")),
                            ],
                            onChanged: (b) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              widget.sendSingle = b;
                            })),
                  ),
                ],
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Path",
                  ),
                  controller: widget._pathTextController,
                ),
              ),
              if (widget.httpMethod != HTTPMethod.GET)
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Parameter"),
                    maxLines: null,
                    controller: widget._parameterTextController,
                  ),
                ),
            ],
          ),
        ),
        trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.removeItem(widget);
              });
            }),
      ),
    );
  }
}
