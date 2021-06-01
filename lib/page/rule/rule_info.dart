import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:auto_route/auto_route_annotations.dart';

class RuleInfoPage extends StatefulWidget {
  final String id;
  RuleInfoPage(@PathParam("id") this.id);

  @override
  _RuleInfoPageState createState() => _RuleInfoPageState();
}

class _RuleInfoPageState extends State<RuleInfoPage> {
  Future<Map<String, dynamic>> _getRuleInfo() async {
    Map<String, dynamic> data;
    await MyHttp.get('/rule-engine/rules/${widget.id}').then((value) {
      data = Map.from(value);
    });

    return Future.value(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("规则信息"),
      ),
      body: FutureBuilder(
          future: _getRuleInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Text("请求出现错误，请刷新页面或重试");
              } else {
                List<Widget> ruleInfoForm =
                    (snapshot.data as Map<String, dynamic>).entries.map((ent) {
                  if (ent.key.toString() == "actions") {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: ent.value.map<Widget>((e) {
                          return TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: e.entries.first.key.toString(),
                            ),
                            controller: TextEditingController(
                                text: e.entries.first.value.toString()),
                          );
                        }).toList(),
                      ),
                    );
                  } else if (ent.key.toString() == "options") {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: ent.value.entries.map<Widget>((secondEntry) {
                          return TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: secondEntry.key.toString(),
                            ),
                            controller: TextEditingController(
                                text: secondEntry.value.toString()),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return TextField(
                      decoration: InputDecoration(
                        labelText: ent.key.toString(),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: ent.value.toString(),
                      ),
                    );
                  }
                }).toList();

                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      children: ruleInfoForm,
                    ),
                  ),
                );
              }
            } else {
              return SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
