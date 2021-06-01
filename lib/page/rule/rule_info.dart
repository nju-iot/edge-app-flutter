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
    MaterialColor appBarColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text("规则信息"),
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
          future: _getRuleInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Container(
                  child: Center(
                    child: Text(
                      "请求出现错误，请刷新页面或重试",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                List<Widget> ruleInfoForm =
                    (snapshot.data as Map<String, dynamic>).entries.map((ent) {
                  if (ent.key.toString() == "actions") {
                    return Column(
                      children: ent.value.map<Widget>((e) {
                        print(e is List<String>);
                        print(e.toString());
                        Map<String, dynamic> actionMap =
                            Map.from(e.entries.first.value);
                        print(actionMap.toString());
                        //Map<String,dynamic> action
                        //print(e.entries.first.value.toString());

                        return Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                              top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                e.entries.first.key.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                              ),
                              Column(
                                children: actionMap.entries.map((e2) {
                                  return TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: e2.key.toString(),
                                    ),
                                    controller: TextEditingController(
                                        text: e2.value.toString()),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  } else if (ent.key.toString() == "options") {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor),
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
                    return Container(
                      margin: ent.key.toString() == "sql"
                          ? EdgeInsets.only(top: 20)
                          : null,
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: ent.key.toString(),
                          disabledBorder: ent.key.toString() == "sql"
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                )
                              : null,
                        ),
                        enabled: false,
                        controller: TextEditingController(
                          text: ent.value.toString(),
                        ),
                      ),
                    );
                  }
                }).toList();
                ruleInfoForm.insert(
                    3,
                    Container(
                      child: Row(
                        children: [
                          Container(
                              child: Text("Send the result to log file.")),
                          Expanded(
                            child: Container(
                              child: Switch(
                                value: ((snapshot.data
                                            as Map<String, dynamic>)['actions']
                                        as List)
                                    .contains({"log": {}}),
                                onChanged: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
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
