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
  void _formSubmit() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      MyHttp.postJson("/rule-engine/streams", {"sql": sql}).catchError((error) {
        print(error);
        return showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("错误提示"),
                content: Text(error.response.toString()),
                actions: <Widget>[
                  FlatButton(
                    child: Text("确认"),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            });
      }).then((value) {
        print(value.toString());
        Navigator.of(context).pop(true);
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
