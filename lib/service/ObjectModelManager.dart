// To parse this JSON data, do
//
//     final machineObjectModel = machineObjectModelFromJson(jsonString);

import 'dart:convert';

MachineObjectModel machineObjectModelFromJson(String str) => MachineObjectModel.fromJson(json.decode(str));


class MachineObjectModel {
  MachineObjectModel({
    this.key,
    this.flags,
    this.result,
  });

  String? key;
  String? flags;
  Result? result;

  factory MachineObjectModel.fromJson(Map<String, dynamic> json) => MachineObjectModel(
    key: json["key"],
    flags: json["flags"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );


}

class Result {
  Result({
    this.boards,
    this.fans,
    this.heat,
    this.inputs,
    this.job,
    this.move,
    this.sensors,
    this.seqs,
    this.spindles,
    this.state,
    this.tools,
  });

  List<Board>? boards;
  List<Fan?>? fans;
  Heat? heat;
  List<Input>? inputs;
  Job? job;
  Move? move;
  Sensors? sensors;
  Seqs? seqs;
  List<Spindle>? spindles;
  StateClass? state;
  List<Tool>? tools;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    boards: json["boards"] == null ? [] : List<Board>.from(json["boards"]!.map((x) => Board.fromJson(x))),
    fans: json["fans"] == null ? [] : List<Fan?>.from(json["fans"]!.map((x) => x == null ? null : Fan.fromJson(x))),
    heat: json["heat"] == null ? null : Heat.fromJson(json["heat"]),
    inputs: json["inputs"] == null ? [] : List<Input>.from(json["inputs"]!.map((x) => Input.fromJson(x))),
    job: json["job"] == null ? null : Job.fromJson(json["job"]),
    move: json["move"] == null ? null : Move.fromJson(json["move"]),
    sensors: json["sensors"] == null ? null : Sensors.fromJson(json["sensors"]),
    seqs: json["seqs"] == null ? null : Seqs.fromJson(json["seqs"]),
    spindles: json["spindles"] == null ? [] : List<Spindle>.from(json["spindles"]!.map((x) => Spindle.fromJson(x))),
    state: json["state"] == null ? null : StateClass.fromJson(json["state"]),
    tools: json["tools"] == null ? [] : List<Tool>.from(json["tools"]!.map((x) => Tool.fromJson(x))),
  );


}

class Board {
  Board({
    this.mcuTemp,
    this.v12,
    this.vIn,
  });

  McuTemp? mcuTemp;
  McuTemp? v12;
  McuTemp? vIn;

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    mcuTemp: json["mcuTemp"] == null ? null : McuTemp.fromJson(json["mcuTemp"]),
    v12: json["v12"] == null ? null : McuTemp.fromJson(json["v12"]),
    vIn: json["vIn"] == null ? null : McuTemp.fromJson(json["vIn"]),
  );


}

class McuTemp {
  McuTemp({
    this.current,
  });

  double? current;

  factory McuTemp.fromJson(Map<String, dynamic> json) => McuTemp(
    current: json["current"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "current": current,
  };
}

class Fan {
  Fan({
    this.actualValue,
    this.requestedValue,
    this.rpm,
  });

  double? actualValue = 0;
  double? requestedValue= 0;
  double? rpm = 0;

  factory Fan.fromJson(Map<String, dynamic> json) => Fan(
    actualValue: json["actualValue"],
    requestedValue: json["requestedValue"],
    rpm: json["rpm"],
  );


}

class Heat {
  Heat({
    this.heaters,
  });

  List<Heater>? heaters;

  factory Heat.fromJson(Map<String, dynamic> json) => Heat(
    heaters: json["heaters"] == null ? [] : List<Heater>.from(json["heaters"]!.map((x) => Heater.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "heaters": heaters == null ? [] : List<dynamic>.from(heaters!.map((x) => x.toJson())),
  };
}

class Heater {
  Heater({
    this.active,
    this.avgPwm,
    this.current,
    this.standby,
    this.state,
  });

  double? active;
  double? avgPwm;
  double? current;
  double? standby;
  String? state;

  factory Heater.fromJson(Map<String, dynamic> json) => Heater(
    active: json["active"],
    avgPwm: json["avgPwm"],
    current: json["current"]?.toDouble(),
    standby: json["standby"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "avgPwm": avgPwm,
    "current": current,
    "standby": standby,
    "state": state,
  };
}

class Input {
  Input({
    this.feedRate,
    this.inMacro,
    this.lineNumber,
    this.state,
  });

  double? feedRate;
  bool? inMacro;
  double? lineNumber;
  StateEnum? state;

  factory Input.fromJson(Map<String, dynamic> json) => Input(
    feedRate: json["feedRate"],
    inMacro: json["inMacro"],
    lineNumber: json["lineNumber"],
    state: stateEnumValues.map[json["state"]]!,
  );

  Map<String, dynamic> toJson() => {
    "feedRate": feedRate,
    "inMacro": inMacro,
    "lineNumber": lineNumber,
    "state": stateEnumValues.reverse[state],
  };
}

enum StateEnum { WAITING, IDLE }

final stateEnumValues = EnumValues({
  "idle": StateEnum.IDLE,
  "waiting": StateEnum.WAITING
});

class Job {
  Job({
    this.build,
    this.duration,
    this.filePosition,
    this.layer,
    this.layerTime,
    this.pauseDuration,
    this.rawExtrusion,
    this.timesLeft,
    this.warmUpDuration,
  });

  Build? build;
  double? duration = 0;
  double? filePosition = 0;
  double? layer = 0;
  double? layerTime= 0;
  double? pauseDuration= 0;
  double? rawExtrusion= 0;
  TimesLeft? timesLeft;
  double? warmUpDuration= 0;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    build: json["build"] == null ? null : Build.fromJson(json["build"]),
    duration: json["duration"],
    filePosition: json["filePosition"],
    layer: json["layer"],
    layerTime: json["layerTime"],
    pauseDuration: json["pauseDuration"],
    rawExtrusion: json["rawExtrusion"],
    timesLeft: json["timesLeft"] == null ? null : TimesLeft.fromJson(json["timesLeft"]),
    warmUpDuration: json["warmUpDuration"],
  );

}

class Build {
  Build({
    this.currentObject,
  });

  double? currentObject;

  factory Build.fromJson(Map<String, dynamic> json) => Build(
    currentObject: json["currentObject"],
  );

  Map<String, dynamic> toJson() => {
    "currentObject": currentObject,
  };
}

class TimesLeft {
  TimesLeft({
    this.filament,
    this.file,
    this.slicer,
  });

  dynamic filament;
  dynamic file;
  dynamic slicer;

  factory TimesLeft.fromJson(Map<String, dynamic> json) => TimesLeft(
    filament: json["filament"],
    file: json["file"],
    slicer: json["slicer"],
  );

  Map<String, dynamic> toJson() => {
    "filament": filament,
    "file": file,
    "slicer": slicer,
  };
}

class Move {
  Move({
    this.axes,
    this.currentMove,
    this.extruders,
    this.virtualEPos,
  });

  List<Axe>? axes;
  CurrentMove? currentMove;
  List<Extruder>? extruders;
  double? virtualEPos;

  factory Move.fromJson(Map<String, dynamic> json) => Move(
    axes: json["axes"] == null ? [] : List<Axe>.from(json["axes"]!.map((x) => Axe.fromJson(x))),
    currentMove: json["currentMove"] == null ? null : CurrentMove.fromJson(json["currentMove"]),
    extruders: json["extruders"] == null ? [] : List<Extruder>.from(json["extruders"]!.map((x) => Extruder.fromJson(x))),
    virtualEPos: json["virtualEPos"],
  );

  Map<String, dynamic> toJson() => {
    "axes": axes == null ? [] : List<dynamic>.from(axes!.map((x) => x.toJson())),
    "currentMove": currentMove?.toJson(),
    "extruders": extruders == null ? [] : List<dynamic>.from(extruders!.map((x) => x.toJson())),
    "virtualEPos": virtualEPos,
  };
}

class Axe {
  Axe({
    this.machinePosition,
    this.userPosition,
  });

  double? machinePosition;
  double? userPosition;

  factory Axe.fromJson(Map<String, dynamic> json) => Axe(
    machinePosition: json["machinePosition"]?.toDouble(),
    userPosition: json["userPosition"],
  );

  Map<String, dynamic> toJson() => {
    "machinePosition": machinePosition,
    "userPosition": userPosition,
  };
}

class CurrentMove {
  CurrentMove({
    this.acceleration,
    this.deceleration,
    this.laserPwm,
    this.requestedSpeed,
    this.topSpeed,
  });

  double? acceleration;
  double? deceleration;
  dynamic laserPwm;
  double? requestedSpeed;
  double? topSpeed;

  factory CurrentMove.fromJson(Map<String, dynamic> json) => CurrentMove(
    acceleration: json["acceleration"],
    deceleration: json["deceleration"],
    laserPwm: json["laserPwm"],
    requestedSpeed: json["requestedSpeed"],
    topSpeed: json["topSpeed"],
  );

  Map<String, dynamic> toJson() => {
    "acceleration": acceleration,
    "deceleration": deceleration,
    "laserPwm": laserPwm,
    "requestedSpeed": requestedSpeed,
    "topSpeed": topSpeed,
  };
}

class Extruder {
  Extruder({
    this.position,
    this.rawPosition,
  });

  double? position;
  double? rawPosition;

  factory Extruder.fromJson(Map<String, dynamic> json) => Extruder(
    position: json["position"],
    rawPosition: json["rawPosition"],
  );

  Map<String, dynamic> toJson() => {
    "position": position,
    "rawPosition": rawPosition,
  };
}

class Sensors {
  Sensors({
    this.analog,
    this.endstops,
    this.filamentMonitors,
    this.gpIn,
    this.probes,
  });

  List<Analog>? analog;
  List<Endstop>? endstops;
  List<dynamic>? filamentMonitors;
  List<dynamic>? gpIn;
  List<Probe>? probes;

  factory Sensors.fromJson(Map<String, dynamic> json) => Sensors(
    analog: json["analog"] == null ? [] : List<Analog>.from(json["analog"]!.map((x) => Analog.fromJson(x))),
    endstops: json["endstops"] == null ? [] : List<Endstop>.from(json["endstops"]!.map((x) => Endstop.fromJson(x))),
    filamentMonitors: json["filamentMonitors"] == null ? [] : List<dynamic>.from(json["filamentMonitors"]!.map((x) => x)),
    gpIn: json["gpIn"] == null ? [] : List<dynamic>.from(json["gpIn"]!.map((x) => x)),
    probes: json["probes"] == null ? [] : List<Probe>.from(json["probes"]!.map((x) => Probe.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "analog": analog == null ? [] : List<dynamic>.from(analog!.map((x) => x.toJson())),
    "endstops": endstops == null ? [] : List<dynamic>.from(endstops!.map((x) => x.toJson())),
    "filamentMonitors": filamentMonitors == null ? [] : List<dynamic>.from(filamentMonitors!.map((x) => x)),
    "gpIn": gpIn == null ? [] : List<dynamic>.from(gpIn!.map((x) => x)),
    "probes": probes == null ? [] : List<dynamic>.from(probes!.map((x) => x.toJson())),
  };
}

class Analog {
  Analog({
    this.lastReading,
  });

  double? lastReading;

  factory Analog.fromJson(Map<String, dynamic> json) => Analog(
    lastReading: json["lastReading"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lastReading": lastReading,
  };
}

class Endstop {
  Endstop({
    this.triggered,
  });

  bool? triggered;

  factory Endstop.fromJson(Map<String, dynamic> json) => Endstop(
    triggered: json["triggered"],
  );

  Map<String, dynamic> toJson() => {
    "triggered": triggered,
  };
}

class Probe {
  Probe({
    this.value,
  });

  List<double>? value;

  factory Probe.fromJson(Map<String, dynamic> json) => Probe(
    value: json["value"] == null ? [] : List<double>.from(json["value"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x)),
  };
}

class Seqs {
  Seqs({
    this.boards,
    this.directories,
    this.fans,
    this.global,
    this.heat,
    this.inputs,
    this.job,
    this.move,
    this.network,
    this.reply,
    this.sensors,
    this.spindles,
    this.state,
    this.tools,
    this.volChanges,
    this.volumes,
  });

  double? boards;
  double? directories;
  double? fans;
  double? global;
  double? heat;
  double? inputs;
  double? job;
  double? move;
  double? network;
  double? reply;
  double? sensors;
  double? spindles;
  double? state;
  double? tools;
  List<double>? volChanges;
  double? volumes;

  factory Seqs.fromJson(Map<String, dynamic> json) => Seqs(
    boards: json["boards"],
    directories: json["directories"],
    fans: json["fans"],
    global: json["global"],
    heat: json["heat"],
    inputs: json["inputs"],
    job: json["job"],
    move: json["move"],
    network: json["network"],
    reply: json["reply"],
    sensors: json["sensors"],
    spindles: json["spindles"],
    state: json["state"],
    tools: json["tools"],
    volChanges: json["volChanges"] == null ? [] : List<double>.from(json["volChanges"]!.map((x) => x)),
    volumes: json["volumes"],
  );

  Map<String, dynamic> toJson() => {
    "boards": boards,
    "directories": directories,
    "fans": fans,
    "global": global,
    "heat": heat,
    "inputs": inputs,
    "job": job,
    "move": move,
    "network": network,
    "reply": reply,
    "sensors": sensors,
    "spindles": spindles,
    "state": state,
    "tools": tools,
    "volChanges": volChanges == null ? [] : List<dynamic>.from(volChanges!.map((x) => x)),
    "volumes": volumes,
  };
}

class Spindle {
  Spindle({
    this.current,
    this.state,
  });

  double? current;
  String? state;

  factory Spindle.fromJson(Map<String, dynamic> json) => Spindle(
    current: json["current"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "current": current,
    "state": state,
  };
}

class StateClass {
  StateClass({
    this.currentTool,
    this.gpOut,
    this.laserPwm,
    this.msUpTime,
    this.status,
    this.time,
    this.upTime,
  });

  double? currentTool;
  List<dynamic>? gpOut;
  dynamic laserPwm;
  double? msUpTime;
  String? status;
  DateTime? time;
  double? upTime;

  factory StateClass.fromJson(Map<String, dynamic> json) => StateClass(
    currentTool: json["currentTool"],
    gpOut: json["gpOut"] == null ? [] : List<dynamic>.from(json["gpOut"]!.map((x) => x)),
    laserPwm: json["laserPwm"],
    msUpTime: json["msUpTime"],
    status: json["status"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    upTime: json["upTime"],
  );

  Map<String, dynamic> toJson() => {
    "currentTool": currentTool,
    "gpOut": gpOut == null ? [] : List<dynamic>.from(gpOut!.map((x) => x)),
    "laserPwm": laserPwm,
    "msUpTime": msUpTime,
    "status": status,
    "time": time?.toIso8601String(),
    "upTime": upTime,
  };
}

class Tool {
  Tool({
    this.active,
    this.isRetracted,
    this.standby,
    this.state,
  });

  List<dynamic>? active;
  bool? isRetracted;
  List<dynamic>? standby;
  String? state;

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
    active: json["active"] == null ? [] : List<dynamic>.from(json["active"]!.map((x) => x)),
    isRetracted: json["isRetracted"],
    standby: json["standby"] == null ? [] : List<dynamic>.from(json["standby"]!.map((x) => x)),
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "active": active == null ? [] : List<dynamic>.from(active!.map((x) => x)),
    "isRetracted": isRetracted,
    "standby": standby == null ? [] : List<dynamic>.from(standby!.map((x) => x)),
    "state": state,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
