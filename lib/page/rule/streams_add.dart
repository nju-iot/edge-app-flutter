import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';

class StreamsAddPage extends StatefulWidget {
  const StreamsAddPage({Key key}) : super(key: key);

  @override
  _StreamsAddPageState createState() => _StreamsAddPageState();
}

class _StreamsAddPageState extends State<StreamsAddPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String defaultInput = 'create stream demo () WITH ( FORMAT = \"json\",'
      ' TYPE=\"edgex\")';
  String sql = "";

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

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoadingDialog();
      MyHttp.postJson("/rule-engine/streams", {"sql": sql})
          .then((value) => Navigator.of(context).pop())
          .catchError((error) {
        print(error);
        return showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("错误提示"),
                content:
                    (error as DioError).type == DioErrorType.CONNECT_TIMEOUT
                        ? Text("连接超时，请检查网络情况")
                        : Text(error.response.toString()),
                actions: <Widget>[
                  FlatButton(
                    child: Text("确认"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            }).whenComplete(() => Navigator.of(context).pop());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("新增流")),
      floatingActionButton: FloatingActionButton(
        onPressed: _formSubmit,
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: TextFormField(
            style: TextStyle(height: 1.5),
            validator: (str) {
              if (str == "") {
                return "SQL语句不得为空";
              } else {
                return null;
              }
            },
            onSaved: (str) {
              sql = str;
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue),
              ),
              labelText: "SQL",
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            maxLines: null,
            initialValue: defaultInput,
          ),
        ),
      ),
    );
  }
}
