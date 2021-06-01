import 'dart:convert';

import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter/material.dart';

class StreamInfoPage extends StatefulWidget {
  final String name;
  StreamInfoPage(@PathParam("name") this.name);

  @override
  _StreamInfoPageState createState() => _StreamInfoPageState();
}

class _StreamInfoPageState extends State<StreamInfoPage> {
  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("数据流信息"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: FutureBuilder(
        future: MyHttp.get("/rule-engine/streams/${widget.name}"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return Text("请求出现错误，请刷新页面或重试");
            } else {
              List<Widget> steamInfoForm =
                  (snapshot.data as Map<String, dynamic>).entries.map((entry) {
                if (entry.key.toString() == "Options") {
                  //额外针对Options再扩展出来

                  return Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: entry.value.entries.map<Widget>((secondEntry) {
                        return TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: secondEntry.key.toString(),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          controller: TextEditingController(
                              text: secondEntry.value.toString()),
                        );
                      }).toList(),
                    ),
                  );
                }
                return TextField(
                  decoration: InputDecoration(
                    labelText: entry.key.toString(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  enabled: false,
                  controller:
                      TextEditingController(text: entry.value.toString()),
                );
              }).toList();
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    children: steamInfoForm,
                  ),
                ),
              );
            }
          } else {
            return SizedBox(
                height: 300, child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
