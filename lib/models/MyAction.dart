import 'package:auto_route/auto_route.dart';

class MyAction {
  final String id;
  final int created;
  final int modified;
  final String name;
  final String interval;
  final String target;
  final String protocol;
  final String httpMethod;
  final String address;
  final int port;
  String path;
  String parameters;

  MyAction(
      this.id,
      this.created,
      this.modified,
      this.name,
      this.interval,
      this.target,
      this.protocol,
      this.httpMethod,
      this.address,
      this.port,
      this.path,
      this.parameters);

  MyAction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        created = json['created'],
        modified = json['modified'],
        name = json['name'],
        interval = json['interval'],
        target = json['target'],
        protocol = json['protocol'],
        httpMethod = json['httpMethod'],
        address = json['address'],
        port = json['port'],
        path = json['path'],
        parameters = json['parameters'];

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'created': this.created,
      'modified': this.modified,
      'name': this.name,
      'interval': this.interval,
      'target': this.target,
      'protocol': this.protocol,
      'httpMethod': this.httpMethod,
      'address': this.address,
      'port': this.port,
      'path': this.path,
      'parameters': this.parameters,
    };
  }
}
