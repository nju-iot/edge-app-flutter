import 'package:auto_route/auto_route.dart';
enum FrequencyMode{runOnce,timeExp,cronExp}

class MyInterval{
  final String id;
  final String name;
  final String start;
  final String end;
  final String frequency;
  final Timestamps timestamps;

  //可选
  String cron;
  bool runOnce;
  FrequencyMode frequencyMode;
  MyInterval(this.id,this.name,this.start,this.end,this.frequency,this.timestamps,{this.cron,this.runOnce}){
    if(this.runOnce){
      frequencyMode=FrequencyMode.runOnce;
    }else if(this.cron!=null){
      frequencyMode=FrequencyMode.cronExp;
    }else{
      frequencyMode=FrequencyMode.timeExp;
    }

  }

  MyInterval.fromJson(Map<String,dynamic> json)
    :name=json['name'],
    id=json['id'],
    start=json['start'],
    end=json['end'],
    frequency=json['frequency'],
    timestamps=Timestamps(json['Timestamps']['created'], json['Timestamps']['modified']),
    runOnce=json['runOnce'],
    cron=json['cron']
  {
    if(json['runOnce']==true){
      frequencyMode=FrequencyMode.runOnce;
    }else if(json['cron']!=null){
      frequencyMode=FrequencyMode.cronExp;
    }else{
      frequencyMode=FrequencyMode.timeExp;
    }
  }

  Map<String,dynamic> toJson(){
    return {
      'id':this.id,
      'name':this.name,
      'start':this.start,
      'end':this.end,
      'frequency':this.frequency,
      'Timestamps':{
        "created":this.timestamps.created,
        "modified":this.timestamps.modified,
      },
      if(this.frequencyMode==FrequencyMode.runOnce)
        "runOnce":true,
      if(this.frequencyMode==FrequencyMode.cronExp)
        "cron":this.cron,
    };
  }
}

class Timestamps{
  final int created;
  final int modified;
  Timestamps(this.created,this.modified);

}