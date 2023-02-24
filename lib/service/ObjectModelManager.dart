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
    key: json["key"] == null ? null : json["key"],
    flags: json["flags"] == null ? null : json["flags"],
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
    this.statee,
    this.tools,
  });

  List<Board>? boards;
  List<Fan>? fans;
  Heat? heat;
  List<Input>? inputs;
  Job? job;
  Move? move;
  Sensors? sensors;
  Seqs? seqs;
  List<Spindle>? spindles;
  Statee? statee;
  List<Tool>? tools;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    boards: json["boards"] == null ? null : List<Board>.from(json["boards"].map((x) => Board.fromJson(x))),
    fans: json["fans"] == null ? null : List<Fan>.from(json["fans"].map((x) => Fan.fromJson(x))),
    heat: json["heat"] == null ? null : Heat.fromJson(json["heat"]),
    inputs: json["inputs"] == null ? null : List<Input>.from(json["inputs"].map((x) => Input.fromJson(x))),
    job: json["job"] == null ? null : Job.fromJson(json["job"]),
    move: json["move"] == null ? null : Move.fromJson(json["move"]),
    sensors: json["sensors"] == null ? null : Sensors.fromJson(json["sensors"]),
    seqs: json["seqs"] == null ? null : Seqs.fromJson(json["seqs"]),
    spindles: json["spindles"] == null ? null : List<Spindle>.from(json["spindles"].map((x) => Spindle.fromJson(x))),
    statee: json["state"] == null ? null : Statee.fromJson(json["state"]),
    tools: json["tools"] == null ? null : List<Tool>.from(json["tools"].map((x) => Tool.fromJson(x))),
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

  Map<String, dynamic> toJson() => {
    "mcuTemp": mcuTemp == null ? null : mcuTemp!.toJson(),
    "v12": v12 == null ? null : v12!.toJson(),
    "vIn": vIn == null ? null : vIn!.toJson(),
  };
}

class McuTemp {
  McuTemp({
    this.current,
  });

  double? current;

  factory McuTemp.fromJson(Map<String, dynamic> json) => McuTemp(
    current: json["current"] == null ? null : json["current"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "current": current == null ? null : current,
  };
}

class Fan {
  Fan({
    this.actualValue,
    this.requestedValue,
    this.rpm,
  });

  double? actualValue;
  double? requestedValue;
  double? rpm;

  factory Fan.fromJson(Map<String, dynamic> json) => Fan(
    actualValue: json["actualValue"] == null ? null : json["actualValue"],
    requestedValue: json["requestedValue"] == null ? null : json["requestedValue"],
    rpm: json["rpm"] == null ? null : json["rpm"],
  );

  Map<String, dynamic> toJson() => {
    "actualValue": actualValue == null ? null : actualValue,
    "requestedValue": requestedValue == null ? null : requestedValue,
    "rpm": rpm == null ? null : rpm,
  };
}

class Heat {
  Heat({
    this.heaters,
  });

  List<Heater>? heaters;

  factory Heat.fromJson(Map<String, dynamic> json) => Heat(
    heaters: json["heaters"] == null ? null : List<Heater>.from(json["heaters"].map((x) => Heater.fromJson(x))),
  );

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
    active: json["active"] == null ? null : json["active"],
    avgPwm: json["avgPwm"] == null ? null : json["avgPwm"],
    current: json["current"] == null ? null : json["current"].toDouble(),
    standby: json["standby"] == null ? null : json["standby"],
    state: json["state"] == null ? null : json["state"],
  );

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
  Stat? state;

  factory Input.fromJson(Map<String, dynamic> json) => Input(
    feedRate: json["feedRate"] == null ? null : json["feedRate"],
    inMacro: json["inMacro"] == null ? null : json["inMacro"],
    lineNumber: json["lineNumber"] == null ? null : json["lineNumber"],
    state: json["state"] == null ? null : statValues.map![json["state"]],
  );


}

enum Stat { IDLE }

final statValues = EnumValues({
  "idle": Stat.IDLE
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

  dynamic build;
  dynamic duration;
  double? filePosition;
  dynamic layer;
  dynamic layerTime;
  dynamic pauseDuration;
  dynamic rawExtrusion;
  TimesLeft? timesLeft;
  dynamic warmUpDuration;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    build: json["build"],
    duration: json["duration"],
    filePosition: json["filePosition"] == null ? null : json["filePosition"],
    layer: json["layer"],
    layerTime: json["layerTime"],
    pauseDuration: json["pauseDuration"],
    rawExtrusion: json["rawExtrusion"],
    timesLeft: json["timesLeft"] == null ? null : TimesLeft.fromJson(json["timesLeft"]),
    warmUpDuration: json["warmUpDuration"],
  );

  Map<String, dynamic> toJson() => {
    "build": build,
    "duration": duration,
    "filePosition": filePosition == null ? null : filePosition,
    "layer": layer,
    "layerTime": layerTime,
    "pauseDuration": pauseDuration,
    "rawExtrusion": rawExtrusion,
    "timesLeft": timesLeft == null ? null : timesLeft!.toJson(),
    "warmUpDuration": warmUpDuration,
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
    axes: json["axes"] == null ? null : List<Axe>.from(json["axes"].map((x) => Axe.fromJson(x))),
    currentMove: json["currentMove"] == null ? null : CurrentMove.fromJson(json["currentMove"]),
    extruders: json["extruders"] == null ? null : List<Extruder>.from(json["extruders"].map((x) => Extruder.fromJson(x))),
    virtualEPos: json["virtualEPos"] == null ? null : json["virtualEPos"],
  );

  Map<String, dynamic> toJson() => {
    "axes": axes == null ? null : List<dynamic>.from(axes!.map((x) => x.toJson())),
    "currentMove": currentMove == null ? null : currentMove!.toJson(),
    "extruders": extruders == null ? null : List<dynamic>.from(extruders!.map((x) => x.toJson())),
    "virtualEPos": virtualEPos == null ? null : virtualEPos,
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
    machinePosition: json["machinePosition"] == null ? null : json["machinePosition"],
    userPosition: json["userPosition"] == null ? null : json["userPosition"],
  );

  Map<String, dynamic> toJson() => {
    "machinePosition": machinePosition == null ? null : machinePosition,
    "userPosition": userPosition == null ? null : userPosition,
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
    acceleration: json["acceleration"] == null ? null : json["acceleration"],
    deceleration: json["deceleration"] == null ? null : json["deceleration"],
    laserPwm: json["laserPwm"],
    requestedSpeed: json["requestedSpeed"] == null ? null : json["requestedSpeed"],
    topSpeed: json["topSpeed"] == null ? null : json["topSpeed"],
  );

  Map<String, dynamic> toJson() => {
    "acceleration": acceleration == null ? null : acceleration,
    "deceleration": deceleration == null ? null : deceleration,
    "laserPwm": laserPwm,
    "requestedSpeed": requestedSpeed == null ? null : requestedSpeed,
    "topSpeed": topSpeed == null ? null : topSpeed,
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
    position: json["position"] == null ? null : json["position"],
    rawPosition: json["rawPosition"] == null ? null : json["rawPosition"],
  );

  Map<String, dynamic> toJson() => {
    "position": position == null ? null : position,
    "rawPosition": rawPosition == null ? null : rawPosition,
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
    analog: json["analog"] == null ? null : List<Analog>.from(json["analog"].map((x) => Analog.fromJson(x))),
    endstops: json["endstops"] == null ? null : List<Endstop>.from(json["endstops"].map((x) => Endstop.fromJson(x))),
    filamentMonitors: json["filamentMonitors"] == null ? null : List<dynamic>.from(json["filamentMonitors"].map((x) => x)),
    gpIn: json["gpIn"] == null ? null : List<dynamic>.from(json["gpIn"].map((x) => x)),
    probes: json["probes"] == null ? null : List<Probe>.from(json["probes"].map((x) => Probe.fromJson(x))),
  );


}

class Analog {
  Analog({
    this.lastReading,
  });

  double? lastReading;

  factory Analog.fromJson(Map<String, dynamic> json) => Analog(
    lastReading: json["lastReading"] == null ? null : json["lastReading"].toDouble(),
  );

}

class Endstop {
  Endstop({
    this.triggered,
  });

  bool? triggered;

  factory Endstop.fromJson(Map<String, dynamic> json) => Endstop(
    triggered: json["triggered"] == null ? null : json["triggered"],
  );

  Map<String, dynamic> toJson() => {
    "triggered": triggered == null ? null : triggered,
  };
}

class Probe {
  Probe({
    this.value,
  });

  List<double>? value;

  factory Probe.fromJson(Map<String, dynamic> json) => Probe(
    value: json["value"] == null ? null : List<double>.from(json["value"].map((x) => x)),
  );

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
    boards: json["boards"] == null ? null : json["boards"],
    directories: json["directories"] == null ? null : json["directories"],
    fans: json["fans"] == null ? null : json["fans"],
    global: json["global"] == null ? null : json["global"],
    heat: json["heat"] == null ? null : json["heat"],
    inputs: json["inputs"] == null ? null : json["inputs"],
    job: json["job"] == null ? null : json["job"],
    move: json["move"] == null ? null : json["move"],
    network: json["network"] == null ? null : json["network"],
    reply: json["reply"] == null ? null : json["reply"],
    sensors: json["sensors"] == null ? null : json["sensors"],
    spindles: json["spindles"] == null ? null : json["spindles"],
    state: json["state"] == null ? null : json["state"],
    tools: json["tools"] == null ? null : json["tools"],
    volChanges: json["volChanges"] == null ? null : List<double>.from(json["volChanges"].map((x) => x)),
    volumes: json["volumes"] == null ? null : json["volumes"],
  );

}

class Spindle {
  Spindle({
    this.current,
    this.state,
  });

  double? current;
  String? state;

  factory Spindle.fromJson(Map<String, dynamic> json) => Spindle(
    current: json["current"] == null ? null : json["current"],
    state: json["state"] == null ? null : json["state"],
  );

}

class Statee {
  Statee({
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
  dynamic? laserPwm;
  double? msUpTime;
  String? status;
  DateTime? time;
  double? upTime;

  factory Statee.fromJson(Map<String, dynamic> json) => Statee(
    currentTool: json["currentTool"] == null ? null : json["currentTool"],
    gpOut: json["gpOut"] == null ? null : List<dynamic>.from(json["gpOut"].map((x) => x)),
    laserPwm: json["laserPwm"],
    msUpTime: json["msUpTime"] == null ? null : json["msUpTime"],
    status: json["status"] == null ? null : json["status"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    upTime: json["upTime"] == null ? null : json["upTime"],
  );


}

class Tool {
  Tool({
    this.active,
    this.isRetracted,
    this.standby,
    this.state,
  });

  List<double>? active;
  bool? isRetracted;
  List<double>? standby;
  String? state;

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
    active: json["active"] == null ? null : List<double>.from(json["active"].map((x) => x)),
    isRetracted: json["isRetracted"] == null ? null : json["isRetracted"],
    standby: json["standby"] == null ? null : List<double>.from(json["standby"].map((x) => x)),
    state: json["state"] == null ? null : json["state"],
  );


}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
