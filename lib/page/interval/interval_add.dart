import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/models/MyInterval.dart';

class IntervalAddPage extends StatefulWidget {
  MyInterval intervalInfo;
  bool modify = false; //表示是不是修改
  IntervalAddPage({String intervalString = ""}) {
    if (intervalString != "") {
      intervalString = intervalString
          .replaceAll("%7B", "{")
          .replaceAll("%7D", "}")
          .replaceAll("%20", " ")
          .replaceAll("%22", '"');
      intervalInfo = MyInterval.fromJson(jsonDecode(intervalString));
      modify = true;
      print("intervalAddPage----------------");
      print(intervalInfo.toJson().toString());
    }
  }
  @override
  _IntervalAddPageState createState() => _IntervalAddPageState();
}

class _IntervalAddPageState extends State<IntervalAddPage> {
  FrequencyMode _frequencyMode = FrequencyMode.timeExp;

  DateTime _enterTime; //打开页面的时间，用于开始时间的初始值，以及日期时间选择器的最小值
  bool _runOnce = false; //只运行一次
  TextEditingController _startDateTextController;
  TextEditingController _startTimeTextController;
  TextEditingController _endDateTextController;
  TextEditingController _endTimeTextController;
  TextEditingController _cronExpTextController;
  TextEditingController _frequencyTextController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _postData = {
    "name": "",
    "runOnce": false,
    "frequency": "",
    "start": "",
    "end": "",
    "cron": "",
  };
  void _showLoadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 26.0),
                  child: Text("正在提交"),
                ),
              ],
            ),
          );
        });
  }

  //
  DateTime _isoString2DateTime(String str) {
    return DateTime.utc(
      int.parse(str.substring(0, 4)),
      int.parse(str.substring(4, 6)),
      int.parse(str.substring(6, 8)),
      int.parse(str.substring(9, 11)),
      int.parse(str.substring(11, 13)),
      int.parse(str.substring(13, 15)),
    );
  }

  //提交表单
  void _formSubmit() {
    //TODO: 验证数据正确性
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _postData["runOnce"] = _runOnce;
      print("表单:" + _postData.toString());
      print("验证通过");
      _showLoadingDialog();

      //根据两种情况发出不同请求
      if (widget.modify == false) {
        MyHttp.postJson(':48085/api/v1/interval', _postData).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }).catchError((error) {
          //发生错误，初始化提交表单数据
          _postData = {
            "name": "",
            "runOnce": false,
            "frequency": "",
            "start": "",
            "end": "",
            "cron": "",
          };
          print(error);
          MyHttp.handleError(error);
          return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('错误提示'),
                  content:
                      (error as DioError).type == DioErrorType.CONNECT_TIMEOUT
                          ? Text('连接超时，请检查网络状况或重试')
                          : Text(error.response.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('确认'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              }).whenComplete(() {
            Navigator.of(context).pop(true);
          });
        });
      } else {
        _postData["id"] = widget.intervalInfo.id;
        print(_postData);
        MyHttp.putJson(':48085/api/v1/interval', _postData).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }).catchError((error) {
          //发生错误，初始化提交表单数据
          _postData = {
            "name": "",
            "runOnce": false,
            "frequency": "",
            "start": "",
            "end": "",
            "cron": "",
          };
          print(error);
          print(error.response.toString());
          MyHttp.handleError(error);
          return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content:
                      (error as DioError).type == DioErrorType.CONNECT_TIMEOUT
                          ? Text("连接超时，请检查网络状况或重试")
                          : Text(error.response.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('确认'),
                      onPressed: () {
                        //退出提示框
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              }).whenComplete(() {
            //退出加载框
            Navigator.of(context).pop(true);
          });
        });
      }
      //Navigator.of(context).pop();
    } else {
      print("验证失败");
    }
    //MyHttp.postJson("/support-scheduler/api/v1/interval",)
  }

  @override
  void initState() {
    super.initState();
    //开始时间精度为秒
    DateTime _startDateTime = DateTime.now();
    _enterTime = _startDateTime;
    _startDateTime = DateTime.fromMillisecondsSinceEpoch(
        _startDateTime.millisecondsSinceEpoch -
            _startDateTime.millisecondsSinceEpoch % (1000));

    List<String> _startDateAndTime = _startDateTime.toString().split(" ");

    if (widget.modify == true) {
      String date = widget.intervalInfo.start.split("T")[0];
      _startDateTextController = TextEditingController(
          text: date.substring(0, 4) +
              "-" +
              date.substring(4, 6) +
              "-" +
              date.substring(6));
      print("fuck");
      print(_startDateTextController.text);
      String time = widget.intervalInfo.start.split("T")[1];
      _startTimeTextController = TextEditingController(
        text: time.substring(0, 2) +
            ":" +
            time.substring(2, 4) +
            ":" +
            time.substring(4),
      );
    } else {
      _startDateTextController =
          TextEditingController(text: _startDateAndTime[0]);
      _startTimeTextController = TextEditingController(
          text: _startDateAndTime[1]
              .substring(0, _startDateAndTime[1].length - 4));
    }
    if (widget.modify == true) {
      if (widget.intervalInfo.end != null) {
        String date = widget.intervalInfo.end.split("T")[0];
        String time = widget.intervalInfo.end.split("T")[1];
        _endDateTextController = TextEditingController(
            text: date.substring(0, 4) +
                "-" +
                date.substring(4, 6) +
                "-" +
                date.substring(6));

        _endTimeTextController = TextEditingController(
          text: time.substring(0, 2) +
              ":" +
              time.substring(2, 4) +
              ":" +
              time.substring(4),
        );
      } else {
        _endDateTextController = TextEditingController();
        _endTimeTextController = TextEditingController();
      }
    } else {
      _endDateTextController = TextEditingController();
      _endTimeTextController = TextEditingController();
    }

    _frequencyTextController = TextEditingController();
    _cronExpTextController = TextEditingController();
    if (widget.modify == true) {
      this._frequencyMode = widget.intervalInfo.frequencyMode;
      if (_frequencyMode == FrequencyMode.runOnce) {
        _runOnce = true;
      } else if (_frequencyMode == FrequencyMode.timeExp) {
        _frequencyTextController = TextEditingController(
            text: widget.intervalInfo.frequency
                .substring(0, widget.intervalInfo.frequency.length - 1));
      } else {
        _cronExpTextController =
            TextEditingController(text: widget.intervalInfo.cron);
      }
    }
  }

  //时间选择器,若输入框没有值，则存入当前时间
  void _showTimePicker(TextEditingController _textController) {
    Duration _confirmTime = Duration(
        hours: _enterTime.hour,
        minutes: _enterTime.minute,
        seconds: _enterTime.second);
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return Container(
            height: 400,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                          child: Text("取消"),
                          onPressed: () => Navigator.of(context).pop()),
                      CupertinoButton(
                          child: Text("清空"),
                          onPressed: () {
                            _textController.text = "";
                            Navigator.of(context).pop();
                          }),
                      CupertinoButton(
                          child: Text("确认"),
                          onPressed: () {
                            _textController.text = _confirmTime
                                .toString()
                                .substring(
                                    0, _confirmTime.toString().length - 7);
                            if (_textController.text.length == 7) {
                              _textController.text = "0" + _textController.text;
                            }
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  child: CupertinoTimerPicker(
                    initialTimerDuration: _textController.text == ""
                        ? Duration(
                            hours: _enterTime.hour,
                            minutes: _enterTime.minute,
                            seconds: _enterTime.second)
                        : Duration(
                            hours:
                                int.parse(_textController.text.split(":")[0]),
                            minutes:
                                int.parse(_textController.text.split(":")[1]),
                            seconds:
                                int.parse(_textController.text.split(":")[2]),
                          ),
                    mode: CupertinoTimerPickerMode.hms,
                    onTimerDurationChanged: (selectedTime) {
                      _confirmTime = selectedTime;
                      print("Start Timepicker: ${selectedTime.toString()}");
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  //日期选择器
  void _showDatePicker(TextEditingController _textController) {
    DateTime _selectedDateTime = _enterTime; //保存选择的时间
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 400,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text("取消"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                        child: Text("清空"),
                        onPressed: () {
                          _textController.text = "";
                          Navigator.of(context).pop();
                        }),
                    CupertinoButton(
                      child: Text("确认"),
                      onPressed: () {
                        setState(() {
                          _textController.text =
                              _selectedDateTime.toString().substring(0, 10);
                        });
                        print("该Controller的text为" + _textController.text);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 300,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _textController.text != ""
                      ? DateTime.parse(_textController.text)
                      : _enterTime,
                  onDateTimeChanged: (selectedDate) {
                    _selectedDateTime = selectedDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modify == false ? "新增定时任务" : "修改定时任务"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _formSubmit,
        child: Icon(Icons.add),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                style: widget.modify == false
                    ? null
                    : TextStyle(color: Colors.grey),
                enabled: widget.modify == false,
                initialValue:
                    widget.modify == true ? widget.intervalInfo.name : "",
                onSaved: (text) => _postData['name'] = text,
                validator: (str) => str != "" ? null : "名称不得为空",
                decoration: InputDecoration(
                  labelText: "名称",
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "请输入名称",
                ),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (str) {
                        if (str == "") {
                          return "请选择开始日期";
                        }
                        return null;
                      },
                      onSaved: (startTimeStr) {
                        _postData["start"] =
                            startTimeStr.replaceAll("-", "") + "T";
                      },
                      onTap: () {
                        _showDatePicker(_startDateTextController);
                      },
                      controller: _startDateTextController,
                      readOnly: true,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: "开始日期",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value == "") {
                            return "请选择开始时间";
                          }
                          return null;
                        },
                        onSaved: (str) {
                          _postData["start"] =
                              _postData["start"] + str.replaceAll(":", "");
                        },
                        onTap: () {
                          _showTimePicker(_startTimeTextController);
                        },
                        controller: _startTimeTextController,
                        readOnly: true,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: "时间",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
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
                      autovalidateMode: AutovalidateMode.always,
                      validator: (str) {
                        if (str == "") {
                          if (_endTimeTextController.text != "") {
                            return "请选择结束日期";
                          }
                        }
                      },
                      onSaved: (endTimeStr) {
                        if (endTimeStr != "" && _endDateTextController != "") {
                          _postData["end"] =
                              endTimeStr.replaceAll("-", "") + "T";
                        }
                      },
                      onTap: () {
                        _showDatePicker(_endDateTextController);
                      },
                      controller: _endDateTextController,
                      readOnly: true,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: "结束日期",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (str) {
                          if (str == "") {
                            if (_endDateTextController.text != "") {
                              return "请选择结束时间";
                            }
                          }
                          return null;
                        },
                        onSaved: (str) {
                          _postData["end"] =
                              _postData["end"] + str.replaceAll(":", "");
                        },
                        onTap: () {
                          _showTimePicker(_endTimeTextController);
                        },
                        controller: _endTimeTextController,
                        readOnly: true,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: "时间",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text("仅执行一次"),
                  Switch(
                    value: _runOnce,
                    onChanged: (value) {
                      setState(() {
                        if (value == false) {
                          _frequencyMode = FrequencyMode.timeExp;
                        } else {
                          _frequencyMode = FrequencyMode.runOnce;
                        }
                        _runOnce = value;
                      });
                    },
                  ),
                ],
              ),
              if (!_runOnce)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<FrequencyMode>(
                      onChanged: (FrequencyMode value) {
                        setState(() {
                          setState(() {
                            _frequencyMode = value;
                          });
                        });
                      },
                      value: FrequencyMode.timeExp,
                      groupValue: _frequencyMode,
                    ),
                    Expanded(
                      //TODO: 执行频率如果出现hintText，和时间单位错开
                      child: TextFormField(
                        controller: _frequencyTextController,
                        style: this._frequencyMode == FrequencyMode.timeExp
                            ? TextStyle(color: Colors.black)
                            : TextStyle(color: Colors.grey),
                        validator: (str) {
                          if (_frequencyMode == FrequencyMode.timeExp) {
                            if (str == "") {
                              return "执行频率不得为空";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        enabled: _frequencyMode == FrequencyMode.timeExp,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSaved: (value) {
                          if (_frequencyMode == FrequencyMode.timeExp) {
                            _postData["frequency"] = value;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "执行频率",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 11),
                        child: DropdownButtonFormField(
                          value: (widget.modify == true &&
                                  widget.intervalInfo.frequencyMode ==
                                      FrequencyMode.timeExp)
                              ? (widget.intervalInfo.frequency.substring(
                                  widget.intervalInfo.frequency.length - 1))
                              : "h",
                          items: [
                            DropdownMenuItem(
                              value: "h",
                              child: Text("Hour"),
                            ),
                            DropdownMenuItem(value: "m", child: Text("Minute")),
                            DropdownMenuItem(
                              value: "s",
                              child: Text("Second"),
                            ),
                          ],
                          onChanged:
                              this._frequencyMode == FrequencyMode.timeExp
                                  ? (str) => {}
                                  : null,
                          //TODO: 根据时间单位修改频率字符串
                          onSaved: (String str) {
                            if (_frequencyMode == FrequencyMode.timeExp) {
                              _postData['frequency'] =
                                  _postData['frequency'] + str;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              if (!_runOnce)
                Row(
                  children: [
                    Radio<FrequencyMode>(
                      onChanged: (FrequencyMode value) {
                        setState(() {
                          _frequencyMode = value;
                        });
                      },
                      value: FrequencyMode.cronExp,
                      groupValue: _frequencyMode,
                    ),
                    Expanded(
                      child: TextFormField(
                        style: this._frequencyMode == FrequencyMode.cronExp
                            ? TextStyle(color: Colors.black)
                            : TextStyle(color: Colors.grey),
                        controller: _cronExpTextController,
                        validator: (str) {
                          if (_frequencyMode == FrequencyMode.cronExp) {
                            if (str == "") {
                              return "Cron表达式不能为空";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        enabled: _frequencyMode == FrequencyMode.cronExp,
                        onSaved: (value) {
                          if (_frequencyMode == FrequencyMode.cronExp) {
                            _postData["cron"] = value;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Cron表达式",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
